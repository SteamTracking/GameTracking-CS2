"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../popups/pet_book_pages.ts" />
/// <reference path="../popups/pet_book_turn.ts" />
var PetBook;
(function (PetBook) {
    const _m_cp = $.GetContextPanel();
    let _m_bar;
    let _m_hint;
    let _m_prev;
    let _m_next;
    let _m_open;
    let _m_chapters = [];
    function Init() {
        GameInterfaceAPI.SetChickenAudioSuppressed('pet_book', true);
        _m_bar = _m_cp.FindChildInLayoutFile('id-pet-book-bar');
        _m_hint = _m_cp.FindChildInLayoutFile('id-pet-book-hint');
        _m_prev = _m_cp.FindChildInLayoutFile('id-pet-book-prev');
        _m_next = _m_cp.FindChildInLayoutFile('id-pet-book-next');
        _m_open = _m_cp.FindChildInLayoutFile('id-pet-book-open-btn');
        PetBookPages.Init(PetBookTurn.RefreshSpread);
        _m_cp.FindChildInLayoutFile('id-pet-book-booth-btn').visible =
            _m_cp.GetAttributeInt('from_booth', 0) === 1 && PetBookPages.HasLivePet();
        PetBookTurn.Init({
            FillPage: PetBookPages.FillPage,
            OnBeforeTurn: PetBookPages.CloseFrame,
            OnSpreadChanged: _UpdateNav,
        }, PetBookPages.ShownPages(), _m_cp.GetAttributeInt('spread', 0));
        _MakeChapterButtons();
        _UpdateNav();
        if (PetBookTurn.Spread() > 0) {
            $.DispatchEvent('CSGOPlaySoundEffect', 'UI.BookOpen', 'MOUSE');
        }
    }
    PetBook.Init = Init;
    function Next() {
        PetBookTurn.TurnTo(PetBookTurn.Spread() + 1);
    }
    PetBook.Next = Next;
    function Prev() {
        PetBookTurn.TurnTo(PetBookTurn.Spread() - 1);
    }
    PetBook.Prev = Prev;
    function OpenPhotoBooth() {
        if (!PetBookPages.HasLivePet()) {
            return;
        }
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_pet_photobooth.xml', 'pet_id=' + PetBookPages.PetItemID()
            + '&' + 'upgrade_level=' + PetBookPages.PetStage()
            + '&' + 'book_spread=' + PetBookTurn.Spread()
            + '&' + 'booth_setup=' + _m_cp.GetAttributeString('booth_setup', '')
            + '&' + 'from_book=1');
        Close();
    }
    PetBook.OpenPhotoBooth = OpenPhotoBooth;
    function Close() {
        PetBookPages.CancelDrag();
        GameInterfaceAPI.SetChickenAudioSuppressed('pet_book', false);
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('CSGOPlaySoundEffect', PetBookTurn.Spread() > 0 ? 'UI.BookClose' : 'UIPanorama.mainmenu_press_quit', 'MOUSE');
    }
    PetBook.Close = Close;
    function _ChapterBtnId(strName) {
        return 'id-pet-book-chapter-' + strName;
    }
    function _ChapterOfSpread(spread) {
        const aStarted = _m_chapters.filter(chapter => PetBookTurn.SpreadOfPage(chapter.page) <= spread);
        return aStarted[aStarted.length - 1];
    }
    function _MakeChapterButtons() {
        const elParent = _m_cp.FindChildInLayoutFile('id-pet-book-chapters');
        _m_chapters = PetBookPages.Chapters();
        _m_chapters.forEach(chapter => {
            const elBtn = $.CreatePanel('RadioButton', elParent, _ChapterBtnId(chapter.name), {
                class: 'pet-book-chapter',
                group: 'chapters'
            });
            $.CreatePanel('Image', elBtn, '', {
                src: "file://{images}/icons/ui/" + chapter.icon,
                textureheight: "20",
                texturewidth: "-1",
            });
            elBtn.SetPanelEvent('onactivate', () => { PetBookTurn.TurnTo(PetBookTurn.SpreadOfPage(chapter.page)); });
        });
    }
    function _UpdateNav() {
        const spread = PetBookTurn.Spread();
        const closed = spread === 0;
        _m_prev.enabled = spread > 0;
        _m_next.enabled = spread < PetBookTurn.NumSpreads() - 1;
        _m_bar.visible = !closed;
        _m_open.visible = closed;
        _m_hint.style.opacity = closed ? '1' : '0';
        const chapter = _ChapterOfSpread(spread);
        if (chapter) {
            _m_cp.FindChildTraverse(_ChapterBtnId(chapter.name)).checked = true;
        }
        _m_cp.SetDialogVariableInt('page', spread);
        _m_cp.SetDialogVariableInt('total', PetBookTurn.NumSpreads() - 1);
        _m_cp.SetDialogVariable('label', $.Localize('#pet_book_page_counter', _m_cp));
    }
})(PetBook || (PetBook = {}));
