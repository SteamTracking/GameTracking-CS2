"use strict";
/// <reference path="../csgo.d.ts" />
var PetBookTurn;
(function (PetBookTurn) {
    const _m_cp = $.GetContextPanel();
    const PAGE_W = 560;
    const PAGE_H = 640;
    const MARGIN = 8;
    const BOOK_W = PAGE_W * 2 + MARGIN * 2;
    const BOOK_H = PAGE_H + MARGIN * 16;
    const LEFT_X = MARGIN;
    const SPINE_X = MARGIN + PAGE_W;
    const CLOSED_SHIFT = -PAGE_W / 2;
    const FLIP_MS = 650;
    const FRAME_SEC = 0.016;
    const NO_PENDING = -1;
    const PAGE_SHADOW_DX = 4;
    const PAGE_SHADOW_A = 0.40;
    const LEAF_SHADE_MAX = 0.32;
    const BACK_SHADE_BIAS = 1.25;
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
    let _m_spread = 0;
    let _m_busy = false;
    let _m_pending = NO_PENDING;
    let _m_mode = 'page';
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
        _m_book.style.width = BOOK_W + 'px;';
        _m_book.style.height = BOOK_H + 'px;';
        _SizePage(_m_left);
        _SizePage(_m_right);
        _SizePage(_m_leaf);
        _m_left.style.transform = 'translateX( ' + LEFT_X + 'px );';
        _m_right.style.transform = 'translateX( ' + SPINE_X + 'px );';
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
    function _ShadowEnvelope(deg) {
        const rad = deg * Math.PI / 180;
        return _m_mode === 'page' ? Math.abs(Math.sin(rad)) : Math.abs(Math.sin(rad / 2));
    }
    function _SetLeaf(deg) {
        _m_leaf.style.transform = 'rotateY( ' + deg + 'deg );';
        _m_leaf.style.opacity = '1';
        const facingFront = deg > -90 && deg < 90;
        _m_leafFront.style.opacity = facingFront ? '1' : '0';
        _m_leafBack.style.opacity = facingFront ? '0' : '1';
        const lift = Math.abs(Math.sin(deg * Math.PI / 180));
        _m_leafShade.style.opacity = (lift * LEAF_SHADE_MAX * (facingFront ? 1 : BACK_SHADE_BIAS)).toFixed(3);
        _m_leaf.style.boxShadow = PAGE_SHADOW_DX + 'px 8px 26px 0px rgba( 0, 0, 0, '
            + (_ShadowEnvelope(deg) * PAGE_SHADOW_A).toFixed(3) + ' );';
        _SetCastShadow(deg, lift, facingFront);
    }
    function _HideLeaf() {
        _m_leaf.style.opacity = '0';
        _m_leafFront.style.opacity = '0';
        _m_leafBack.style.opacity = '0';
        _m_leafShade.style.opacity = '0';
        _m_leafCast.style.opacity = '0';
        _m_leafFront.RemoveAndDeleteChildren();
        _m_leafBack.RemoveAndDeleteChildren();
        _m_leaf.style.boxShadow = PAGE_SHADOW_DX + 'px 8px 26px 0px rgba( 0, 0, 0, 0 );';
    }
    function _SetCastShadow(deg, lift, overRight) {
        const pageBelow = overRight || _m_mode === 'page';
        if (!pageBelow || lift <= 0) {
            _m_leafCast.style.opacity = '0';
            return;
        }
        const projW = PAGE_W * Math.abs(Math.cos(deg * Math.PI / 180));
        const x = overRight ? SPINE_X + projW : SPINE_X - projW - CAST_W;
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
    function _BuildSides(aPages) {
        _m_sides = [];
        _m_sides.push({ kind: 'blank' });
        _m_sides.push({ kind: 'cover' });
        aPages.forEach(nPage => _m_sides.push({ kind: 'page', num: nPage }));
        if (_m_sides.length % 2 === 0) {
            _m_sides.push({ kind: 'blank' });
        }
        _m_sides.push({ kind: 'back' });
    }
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
        const inner = $.CreatePanel('Panel', container, '', { class: 'pb-page-inner' });
        if (side.kind === 'cover') {
            inner.BLoadLayoutSnippet('page-cover');
        }
        else if (side.kind === 'back') {
            inner.BLoadLayoutSnippet('page-back');
        }
        else {
            _m_host.FillPage(inner, side.num || 0);
        }
    }
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
    function _Ease(t) {
        const s = t * t * (3 - 2 * t);
        return Math.pow(s, 0.72);
    }
    function _Tween(onFrame, onDone) {
        const start = Date.now();
        const tick = () => {
            const t = (Date.now() - start) / FLIP_MS;
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
            if (opening) {
                _m_gutter.style.opacity = (e * GUTTER_MAX).toFixed(3);
            }
            else if (closing) {
                _m_gutter.style.opacity = ((1 - e) * GUTTER_MAX).toFixed(3);
            }
        }, onDone);
    }
    function TurnTo(target) {
        _m_host.OnBeforeTurn();
        const to = _Bound(target);
        if (to === _m_spread) {
            return;
        }
        if (_m_busy) {
            _m_pending = to;
            return;
        }
        _m_busy = true;
        const from = _m_spread;
        const forward = to > from;
        _m_mode = to === 0 ? 'close' : from === 0 ? 'open' : 'page';
        if (forward) {
            _FillSide(_m_right, to * 2 + 1);
            _FillSide(_m_leafFront, from * 2 + 1);
            _FillSide(_m_leafBack, to * 2);
            _SetLeaf(0);
        }
        else {
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
    function _PlayTurnSound(forward) {
        const strSound = _m_mode === 'open' ? 'UI.BookOpen'
            : _m_mode === 'close' ? 'UI.BookClose'
                : forward ? 'UI.BookPageFwd' : 'UI.BookPageBwd';
        $.DispatchEvent('CSGOPlaySoundEffect', strSound, 'MOUSE');
    }
})(PetBookTurn || (PetBookTurn = {}));
