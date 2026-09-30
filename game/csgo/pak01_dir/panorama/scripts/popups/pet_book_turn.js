"use strict";
/// <reference path="../csgo.d.ts" />
//
// Pet Picture Book - the page turn. One leaf hinged on the spine carries the page that is turning,
// and the static pages either side are refilled as it goes over. Nothing here knows what is on a
// page: the host fills them, and is told when the spread changes.
//
// The cover is just the right page of the first view with the left page hidden, so the book opens
// with the same turn that flips every other page.
//
// Layout and animation are all inline style writes from here. CSS 3D animation was not reliable in
// this codebase.
//
var PetBookTurn;
(function (PetBookTurn) {
    const _m_cp = $.GetContextPanel();
    // Geometry lives here, not in the CSS, so it cannot drift from the turn math.
    const PAGE_W = 560;
    const PAGE_H = 640;
    const MARGIN = 8;
    const BOOK_W = PAGE_W * 2 + MARGIN * 2;
    const BOOK_H = PAGE_H + MARGIN * 16;
    const LEFT_X = MARGIN;
    const SPINE_X = MARGIN + PAGE_W;
    const CLOSED_SHIFT = -PAGE_W / 2; // centres the lone cover while closed
    const FLIP_MS = 650;
    const FRAME_SEC = 0.016;
    // Spreads are indexes, so nothing asked for is -1.
    const NO_PENDING = -1;
    // PAGE_SHADOW_* must stay in step with .book-page-left / .book-page-right: the leaf's shadow
    // peaks at the same values the static pages sit at, which is what makes the handoff invisible.
    const PAGE_SHADOW_DX = 4;
    const PAGE_SHADOW_A = 0.40;
    const LEAF_SHADE_MAX = 0.32;
    const BACK_SHADE_BIAS = 1.25; // incoming face reads darker than the outgoing one
    const CAST_MAX = 0.28;
    const CAST_W = 170;
    const GUTTER_MAX = 0.40;
    let _m_host;
    let _m_book;
    let _m_left;
    let _m_right;
    let _m_gutter;
    let _m_leaf;
    let _m_leafFront;
    let _m_leafBack;
    let _m_leafShade;
    let _m_leafCast;
    let _m_sides = [];
    let _m_spread = 0; // spread 0 = the closed cover view
    let _m_busy = false;
    let _m_pending = NO_PENDING; // spread a click asked for mid-flip
    let _m_mode = 'page';
    // aPages is the book in reading order, by page number. startSpread is bounded here rather than
    // trusted: it arrives as a panel attribute and _FillSide indexes _m_sides with it. Does not call
    // OnSpreadChanged - the host reads Spread() once this returns.
    function Init(host, aPages, startSpread) {
        _m_host = host;
        _m_book = _m_cp.FindChildInLayoutFile('id-pet-book');
        _m_left = _m_cp.FindChildInLayoutFile('id-book-left');
        _m_right = _m_cp.FindChildInLayoutFile('id-book-right');
        _m_gutter = _m_cp.FindChildInLayoutFile('id-book-gutter');
        _m_leaf = _m_cp.FindChildInLayoutFile('id-book-leaf');
        _m_leafFront = _m_cp.FindChildInLayoutFile('id-leaf-front');
        _m_leafBack = _m_cp.FindChildInLayoutFile('id-leaf-back');
        _m_leafShade = _m_cp.FindChildInLayoutFile('id-leaf-shade');
        _m_leafCast = _m_cp.FindChildInLayoutFile('id-leaf-cast');
        // A MARGIN of slack around the pages, because overflow:noclip did not take effect here -
        // this is what keeps the turning leaf and the shadows from being clipped.
        _m_book.style.width = BOOK_W + 'px;';
        _m_book.style.height = BOOK_H + 'px;';
        _SizePage(_m_left);
        _SizePage(_m_right);
        _SizePage(_m_leaf);
        _m_left.style.transform = 'translateX( ' + LEFT_X + 'px );';
        _m_right.style.transform = 'translateX( ' + SPINE_X + 'px );';
        // Leaf is right-aligned rather than translated, because its transform is the rotation.
        _m_leaf.style.marginRight = MARGIN + 'px;';
        _m_leaf.style.transform = 'rotateY( 0deg );';
        _m_gutter.style.height = PAGE_H + 'px;';
        _m_leafCast.style.width = CAST_W + 'px;';
        _m_leafCast.style.height = PAGE_H + 'px;';
        _HideLeaf();
        _BuildSides(aPages);
        _ShowSpread(_Bound(startSpread));
    }
    PetBookTurn.Init = Init;
    function Spread() {
        return _m_spread;
    }
    PetBookTurn.Spread = Spread;
    function NumSpreads() {
        return _m_sides.length / 2;
    }
    PetBookTurn.NumSpreads = NumSpreads;
    function _Bound(spread) {
        return Math.max(0, Math.min(spread, NumSpreads() - 1));
    }
    function _SizePage(p) {
        p.style.width = PAGE_W + 'px;';
        p.style.height = PAGE_H + 'px;';
    }
    function _Lerp(a, b, t) {
        return a + (b - a) * t;
    }
    //----------------------------------------------------------------------------------
    // The leaf: one panel hinged on the spine, carrying the page that is turning.
    //----------------------------------------------------------------------------------
    // Strength of the leaf's drop shadow, 0..1. This is the rule that stops shadows popping, and it
    // depends on what is lying flat underneath each end of the arc:
    //
    //  'page'  - a static page at both ends, each already carrying an identical shadow, so the
    //            leaf's must reach 0 at both ends. |sin(deg)|.
    //  open /  - the cover view has no left page, so at -180deg there is nothing underneath and the
    //  close     leaf carries the FULL shadow, handing it to (or taking it from) the static left
    //            page as that page is switched on/off. |sin(deg/2)| ramps 0 -> 1 across the arc.
    function _ShadowEnvelope(deg) {
        const rad = deg * Math.PI / 180;
        return _m_mode === 'page' ? Math.abs(Math.sin(rad)) : Math.abs(Math.sin(rad / 2));
    }
    function _SetLeaf(deg) {
        _m_leaf.style.transform = 'rotateY( ' + deg + 'deg );';
        _m_leaf.style.opacity = '1';
        // Which face shows swaps at -90deg, where the leaf is edge-on with zero projected width, so
        // the swap cannot be seen.
        const facingFront = deg > -90 && deg < 90;
        _m_leafFront.style.opacity = facingFront ? '1' : '0';
        _m_leafBack.style.opacity = facingFront ? '0' : '1';
        // 0 flat, 1 edge-on. Anything about the leaf's own angle rides this, so it is always 0 at the
        // moments the leaf appears or is hidden.
        const lift = Math.abs(Math.sin(deg * Math.PI / 180));
        _m_leafShade.style.opacity = (lift * LEAF_SHADE_MAX * (facingFront ? 1 : BACK_SHADE_BIAS)).toFixed(3);
        // dx stays POSITIVE for the whole turn - do not "fix" it to point left on the back half. The
        // rotation mirrors the leaf (which is why .book-leaf-back has to un-mirror its content) and it
        // mirrors this offset too: local +4 renders as screen -4 past -90deg, matching the left page's
        // own -4px shadow. Flipping the sign here inverts it twice and the shadow jumps to the spine
        // side at the handoff.
        _m_leaf.style.boxShadow = PAGE_SHADOW_DX + 'px 8px 26px 0px rgba( 0, 0, 0, '
            + (_ShadowEnvelope(deg) * PAGE_SHADOW_A).toFixed(3) + ' );';
        _SetCastShadow(deg, lift, facingFront);
    }
    // Leaves the angle where it is; each turn sets its own start angle. Moving it here would risk a
    // one-frame flash if the transform and the opacity miss the same paint.
    function _HideLeaf() {
        _m_leaf.style.opacity = '0';
        _m_leafFront.style.opacity = '0';
        _m_leafBack.style.opacity = '0';
        _m_leafShade.style.opacity = '0';
        _m_leafCast.style.opacity = '0';
        // Emptied, not just faded. The faces hold whole pages, and a page left on the leaf is a second
        // panel carrying the same data-page and data-slot as the one on screen - see _SlotPanel in
        // pet_book_pages.ts, which then has two to choose from and no way to tell which one anybody
        // can see.
        _m_leafFront.RemoveAndDeleteChildren();
        _m_leafBack.RemoveAndDeleteChildren();
        _m_leaf.style.boxShadow = PAGE_SHADOW_DX + 'px 8px 26px 0px rgba( 0, 0, 0, 0 );';
    }
    // Contact shadow the lifted leaf throws on the page below, parked against the leaf's projected
    // edge so it reads as the gap between them.
    function _SetCastShadow(deg, lift, overRight) {
        // Over the left half of an open or close there is no page to catch it.
        const pageBelow = overRight || _m_mode === 'page';
        if (!pageBelow || lift <= 0) {
            _m_leafCast.style.opacity = '0';
            return;
        }
        const projW = PAGE_W * Math.abs(Math.cos(deg * Math.PI / 180));
        const x = overRight ? SPINE_X + projW : SPINE_X - projW - CAST_W;
        // Mirrored on the left half so the gradient keeps darkening toward the leaf.
        _m_leafCast.style.transform = 'translateX( ' + x.toFixed(0) + 'px )'
            + (overRight ? ';' : ' scale3d( -1, 1, 1 );');
        _m_leafCast.style.opacity = (lift * CAST_MAX).toFixed(3);
    }
    function _ApplySpreadState() {
        const closed = _m_spread === 0;
        _m_book.style.transform = 'translateX( ' + (closed ? CLOSED_SHIFT : 0) + 'px );';
        _m_left.style.opacity = closed ? '0' : '1';
        _m_gutter.style.opacity = closed ? '0' : GUTTER_MAX.toFixed(3);
    }
    //----------------------------------------------------------------------------------
    // Content: which side carries what, and filling a side.
    //----------------------------------------------------------------------------------
    function _BuildSides(aPages) {
        _m_sides = [];
        _m_sides.push({ kind: 'blank' });
        _m_sides.push({ kind: 'cover' });
        // In reading order, and their numbers are not their positions: the book leaves pages out.
        aPages.forEach(nPage => _m_sides.push({ kind: 'page', num: nPage }));
        // The odd page out goes BEFORE the back cover, not after it, so the back always lands on the
        // right of the last spread however many pages there are. Nothing about the sections has to be
        // arranged around this - they are ordered for what is on them, and this absorbs the parity.
        if (_m_sides.length % 2 === 0) {
            _m_sides.push({ kind: 'blank' });
        }
        _m_sides.push({ kind: 'back' });
    }
    // Searched, not computed: a page number is not its position once the book leaves pages out.
    // Side 0 is the hidden left of the cover view, and a spread is two sides. 0 for a page that is
    // not in the book.
    function SpreadOfPage(nPage) {
        const index = _m_sides.findIndex(side => side.kind === 'page' && side.num === nPage);
        return index < 0 ? 0 : Math.floor(index / 2);
    }
    PetBookTurn.SpreadOfPage = SpreadOfPage;
    function _FillSide(container, index) {
        container.RemoveAndDeleteChildren();
        const side = _m_sides[index];
        if (!side || side.kind === 'blank') {
            return;
        }
        // Fresh panel per fill: loading a snippet into a panel that already loaded one does not
        // replace the old content.
        const inner = $.CreatePanel('Panel', container, '', { class: 'pb-page-inner' });
        if (side.kind === 'cover') {
            inner.BLoadLayoutSnippet('page-cover');
        }
        else if (side.kind === 'back') {
            inner.BLoadLayoutSnippet('page-back');
        }
        else {
            // What is on a page is the host's. This file only decides which page goes where and how
            // it turns.
            _m_host.FillPage(inner, side.num || 0);
        }
    }
    // Re-reads the spread on screen from the page model. Refuses mid-turn: the leaf is carrying page
    // panels then, and rebuilding them underneath it would tear the animation.
    function RefreshSpread() {
        if (_m_busy) {
            return;
        }
        _ShowSpread(_m_spread);
    }
    PetBookTurn.RefreshSpread = RefreshSpread;
    function _ShowSpread(spread) {
        _m_spread = spread;
        _FillSide(_m_left, spread * 2);
        _FillSide(_m_right, spread * 2 + 1);
        _ApplySpreadState();
    }
    //----------------------------------------------------------------------------------
    // Page turning
    //----------------------------------------------------------------------------------
    // Front-loaded: brisk off the spine, then a long settle. Sub-1 exponent shifts progress earlier
    // without moving the endpoints.
    function _Ease(t) {
        const s = t * t * (3 - 2 * t);
        return Math.pow(s, 0.72);
    }
    function _Tween(onFrame, onDone) {
        const start = Date.now();
        const tick = () => {
            const t = (Date.now() - start) / FLIP_MS; // wall clock, so flips are frame-rate independent
            if (t >= 1) {
                onFrame(1);
                onDone();
                return;
            }
            onFrame(_Ease(t));
            $.Schedule(FRAME_SEC, tick);
        };
        tick();
    }
    function _RunTurn(leafFrom, leafTo, onDone) {
        const opening = _m_mode === 'open';
        const closing = _m_mode === 'close';
        const bookFrom = opening ? CLOSED_SHIFT : 0;
        const bookTo = closing ? CLOSED_SHIFT : 0;
        _Tween((e) => {
            _SetLeaf(_Lerp(leafFrom, leafTo, e));
            if (bookFrom !== bookTo) {
                _m_book.style.transform = 'translateX( ' + _Lerp(bookFrom, bookTo, e).toFixed(0) + 'px );';
            }
            // Gutter travels with the turn instead of snapping on after the page lands.
            if (opening) {
                _m_gutter.style.opacity = (e * GUTTER_MAX).toFixed(3);
            }
            else if (closing) {
                _m_gutter.style.opacity = ((1 - e) * GUTTER_MAX).toFixed(3);
            }
        }, onDone);
    }
    // One turn, however far it goes. The leaf carries the side you leave on its front and the side
    // you arrive on its back, so a jump across chapters costs the same single flip as a step - the
    // spreads passed over are never seen, because they are under the leaf.
    function TurnTo(target) {
        _m_host.OnBeforeTurn();
        // Bounded here so every caller can ask for whatever it likes, dead arrows included.
        const to = _Bound(target);
        if (to === _m_spread) {
            return;
        }
        // Remember where a click that lands mid-flip wanted to go, rather than dropping it.
        if (_m_busy) {
            _m_pending = to;
            return;
        }
        _m_busy = true;
        const from = _m_spread;
        const forward = to > from;
        // Only the two ends of the book have a turn of their own, so a jump between chapters is a plain
        // page turn however far it reaches.
        _m_mode = to === 0 ? 'close' : from === 0 ? 'open' : 'page';
        if (forward) {
            _FillSide(_m_right, to * 2 + 1);
            _FillSide(_m_leafFront, from * 2 + 1);
            _FillSide(_m_leafBack, to * 2);
            _SetLeaf(0);
        }
        else {
            // Closing switches the left page off at once: the leaf arrives lying exactly over it with the
            // same content and the same full shadow, so the swap is invisible. What belongs under the leaf
            // from here is the empty cover view.
            if (_m_mode === 'close') {
                _m_left.style.opacity = '0';
            }
            else {
                _FillSide(_m_left, to * 2);
            }
            _FillSide(_m_leafBack, from * 2);
            _FillSide(_m_leafFront, to * 2 + 1);
            _SetLeaf(-180);
        }
        _m_spread = to;
        _PlayTurnSound(forward);
        _m_host.OnSpreadChanged(to);
        _RunTurn(forward ? 0 : -180, forward ? -180 : 0, () => {
            // The side the leaf was lying over, filled once it is out of the way.
            if (forward) {
                _FillSide(_m_left, to * 2);
            }
            else {
                _FillSide(_m_right, to * 2 + 1);
            }
            _FinishTurn();
        });
    }
    PetBookTurn.TurnTo = TurnTo;
    // Let the settled page paint a frame before hiding the leaf.
    function _FinishTurn() {
        $.Schedule(FRAME_SEC, () => {
            _HideLeaf();
            _ApplySpreadState();
            _m_busy = false;
            const pending = _m_pending;
            _m_pending = NO_PENDING;
            if (pending !== NO_PENDING) {
                TurnTo(pending);
            }
        });
    }
    // One sound per turn, picked by what the turn is - the cover lifting and dropping are the book
    // opening and closing, everything between is a page.
    function _PlayTurnSound(forward) {
        const strSound = _m_mode === 'open' ? 'UI.BookOpen'
            : _m_mode === 'close' ? 'UI.BookClose'
                : forward ? 'UI.BookPageFwd' : 'UI.BookPageBwd';
        $.DispatchEvent('CSGOPlaySoundEffect', strSound, 'MOUSE');
    }
})(PetBookTurn || (PetBookTurn = {}));
