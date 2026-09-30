"use strict";
/// <reference path="../csgo.d.ts" />
var PetPhotoTag;
(function (PetPhotoTag) {
    PetPhotoTag.EXT = '.jpg';
    PetPhotoTag.FILTERS = [
        { id: 0, name: 'normal' },
        { id: 1, name: 'bw' },
        { id: 2, name: 'sepia' },
        { id: 3, name: 'warm' },
        { id: 4, name: 'cool' },
        { id: 5, name: 'crisp' },
        { id: 6, name: 'moonlight' },
        { id: 7, name: 'silvertone' },
        { id: 8, name: 'psychedelic' },
    ];
    PetPhotoTag.ACTIVITIES = [
        { id: 2, name: 'sit', activity: 'trick', variation: 2, icon: 'pet_activity_sit',
            sound: { Chick: 'Chicken.Idle.Single.Chick.PhotoBooth',
                Pullet: 'Chicken.Idle.Single.PhotoBooth',
                Hen: 'Chicken.Idle.Single.PhotoBooth' } },
        { id: 0, name: 'panic', activity: 'panic', icon: 'pet_activity_panic',
            sound: { Chick: 'Chicken.Panic.Chick.PhotoBooth',
                Pullet: 'Chicken.Panic.Pullet.PhotoBooth',
                Hen: 'Chicken.Panic.Hen.PhotoBooth' } },
        { id: 6, name: 'wag', activity: 'trick', variation: 9, icon: 'pet_activity_wag' },
        { id: 4, name: 'moonwalk', activity: 'trick', variation: 5, icon: 'pet_activity_dance' },
        { id: 5, name: 'jump', activity: 'trick', variation: 11, icon: 'pet_activity_jump' },
        { id: 7, name: 'kick', activity: 'trick', variation: 12, icon: 'pet_activity_kick' },
        { id: 1, name: 'fly', activity: 'trick', variation: 1, icon: 'pet_activity_fly' },
    ];
    const GROWTHS = [
        { id: 0, name: 'egg' },
        { id: 1, name: 'chick' },
        { id: 2, name: 'adolescent' },
        { id: 3, name: 'adult' },
    ];
    function GrowthTerm(nGrowth) {
        const aFound = GROWTHS.filter(row => row.id === nGrowth);
        return aFound.length > 0 ? 'growth:' + aFound[0].name : '';
    }
    PetPhotoTag.GrowthTerm = GrowthTerm;
    PetPhotoTag.HEADWEAR = [
        { id: 0, name: 'helmet', model: 'models/photobooth/silly_hats/helmet.vmdl' },
        { id: 1, name: 'armor', model: 'models/photobooth/silly_hats/armor_helmet.vmdl' },
        { id: 2, name: 'alien', model: 'models/photobooth/silly_hats/alien.vmdl' },
        { id: 3, name: 'banana', model: 'models/photobooth/silly_hats/banana.vmdl' },
        { id: 4, name: 'glasses', model: 'models/photobooth/silly_hats/glasses.vmdl' },
        { id: 5, name: 'nose_glasses', model: 'models/photobooth/silly_hats/nose_glasses.vmdl' },
        { id: 6, name: 'party', model: 'models/photobooth/silly_hats/party.vmdl' },
        { id: 7, name: 'sprout', model: 'models/photobooth/silly_hats/sprout.vmdl' },
        { id: 8, name: 'top_hat', model: 'models/photobooth/silly_hats/top_hat.vmdl' },
        { id: 9, name: 'wizard_hat', model: 'models/photobooth/silly_hats/wizard_hat.vmdl' },
    ];
    const ZOOMS = [
        { name: 'wide', band: [0, 9] },
        { name: 'mid', band: [10, 19] },
        { name: 'closeup', band: [20, 25] },
    ];
    PetPhotoTag.STAGES = [
        { id: 0, name: 'studio', map: 'ui/pet_photo_studio', word: '#SFUI_MAP_pet_photo_studio' },
        { id: 1, name: 'picnic', map: 'ui/pet_photo_park', word: '#SFUI_MAP_pet_photo_park' },
        { id: 4, name: 'warehouse', map: 'warehouse_vanity', word: '#SFUI_Map_warehouse', age_requirement: 2 },
        { id: 3, name: 'airport', map: 'ar_baggage_vanity', word: '#SFUI_Map_ar_baggage', achievement: 'visited-ar_baggage' },
        { id: 2, name: 'dust2', map: 'de_dust2_vanity', word: '#SFUI_Map_de_dust2', achievement: 'visited-de_dust2' },
        { id: 5, name: 'mirage', map: 'de_mirage_vanity', word: '#SFUI_Map_de_mirage', achievement: 'visited-de_mirage' },
        { id: 6, name: 'inferno', map: 'de_inferno_vanity', word: '#SFUI_Map_de_inferno', achievement: 'visited-de_inferno' },
        { id: 7, name: 'nuke', map: 'de_nuke_vanity', word: '#SFUI_Map_de_nuke', achievement: 'visited-de_nuke' },
        { id: 8, name: 'cache', map: 'de_cache_vanity', word: '#SFUI_Map_de_cache', achievement: 'visited-de_cache' },
        { id: 9, name: 'train', map: 'de_train_vanity', word: '#SFUI_Map_de_train', achievement: 'visited-de_train' },
        { id: 10, name: 'ancient', map: 'de_ancient_vanity', word: '#SFUI_Map_de_ancient', achievement: 'visited-de_ancient' },
    ];
    PetPhotoTag.ASPECTS = [
        { id: 3, name: '1x1', ratio: 1 },
        { id: 1, name: '4x3', ratio: 4 / 3 },
        { id: 2, name: '5x4', ratio: 5 / 4 },
        { id: 0, name: '16x9', ratio: 16 / 9 },
        { id: 5, name: '3x4', ratio: 3 / 4 },
        { id: 4, name: '4x5', ratio: 4 / 5 },
        { id: 6, name: '9x16', ratio: 9 / 16 },
    ];
    function Orientation(strAspect) {
        const aFound = PetPhotoTag.ASPECTS.filter(row => row.name === strAspect);
        if (aFound.length === 0 || aFound[0].ratio === 1) {
            return '';
        }
        return aFound[0].ratio > 1 ? 'horizontal' : 'vertical';
    }
    PetPhotoTag.Orientation = Orientation;
    function FlipAspect(strAspect) {
        return strAspect.split('x').reverse().join('x');
    }
    PetPhotoTag.FlipAspect = FlipAspect;
    PetPhotoTag.POSES = [
        { name: '0' },
        { name: '8', orbit: 80 },
        { name: '9', orbit: 80 },
        { name: '10', orbit: 80 },
        { name: '2', orbit: 100 },
        { name: '4', orbit: 110 },
        { name: '5', orbit: 80 },
        { name: '6', orbit: 90 },
        { name: '1', orbit: 100 },
        { name: '3', orbit: 100 },
        { name: '7', orbit: 100 },
    ];
    const FIELDS = [
        { letter: 'p', require: ['pose'], words: PetPhotoTag.POSES, caption: '#pet_photo_caption_pose',
            loc: '#pet_photo_booth_pose_' },
        { letter: 'f', require: ['filter'], codes: PetPhotoTag.FILTERS, caption: '#pet_photo_caption_filter',
            loc: '#pet_photo_booth_filter_' },
        { letter: 's', require: ['stage', 'scene'], codes: PetPhotoTag.STAGES, caption: '#pet_photo_caption_stage' },
        { letter: 'g', require: ['growth'], codes: GROWTHS, caption: '#pet_photo_caption_growth',
            loc: '#pet_growth_' },
        { letter: 'a', require: ['aspect'], codes: PetPhotoTag.ASPECTS,
            loc: '#pet_photo_booth_aspect_' },
        { letter: 'z', require: ['zoom'], bands: ZOOMS, caption: '#pet_photo_caption_zoom',
            loc: '#pet_photo_booth_zoom_' },
        { letter: 'v', require: ['activity'], codes: PetPhotoTag.ACTIVITIES, caption: '#pet_photo_caption_activity',
            loc: '#pet_photo_booth_activity_' },
        { letter: 'e', require: ['headwear'], codes: PetPhotoTag.HEADWEAR, caption: '#pet_photo_caption_headwear',
            loc: '#pet_photo_booth_headwear_' },
    ];
    function _RequireIndex() {
        const byName = {};
        FIELDS.forEach(field => { field.require.forEach(name => { byName[name] = field; }); });
        return byName;
    }
    const REQUIRE = _RequireIndex();
    function _IdOf(aValues, strName) {
        const aFound = aValues.filter(value => value.name === strName);
        return aFound.length > 0 ? String(aFound[0].id) : '';
    }
    function _Coded(strLetter, strId, strValue, strTable) {
        if (strId === '') {
            return '';
        }
        return '_' + strLetter + strId;
    }
    function _StageId(strMap) {
        const aFound = PetPhotoTag.STAGES.filter(stage => stage.map === strMap);
        return aFound.length > 0 ? String(aFound[0].id) : '';
    }
    function _HeadwearId(strModel) {
        const aFound = PetPhotoTag.HEADWEAR.filter(row => row.model === strModel);
        return aFound.length > 0 ? String(aFound[0].id) : '';
    }
    function Compose(shot) {
        const strFilter = shot.filter || 'normal';
        const strAspect = shot.aspect || '1x1';
        return '_p' + shot.pose +
            _Coded('f', _IdOf(PetPhotoTag.FILTERS, strFilter), strFilter, 'FILTERS') +
            _Coded('s', _StageId(shot.stageMap), shot.stageMap, 'STAGES') +
            '_g' + shot.growth +
            _Coded('a', _IdOf(PetPhotoTag.ASPECTS, strAspect), strAspect, 'ASPECTS') +
            '_z' + shot.zoom +
            (shot.activity === '' ? '' : _Coded('v', _IdOf(PetPhotoTag.ACTIVITIES, shot.activity), shot.activity, 'ACTIVITIES')) +
            (shot.headwear === '' ? '' : _Coded('e', _HeadwearId(shot.headwear), shot.headwear, 'HEADWEAR'));
    }
    PetPhotoTag.Compose = Compose;
    function Parse(strFileName) {
        const fields = {};
        const aTokens = strFileName.replace(PetPhotoTag.EXT, '').split('_');
        for (let i = 2; i < aTokens.length; i++) {
            if (aTokens[i].length > 1) {
                fields[aTokens[i].charAt(0)] = aTokens[i].substring(1);
            }
        }
        return fields;
    }
    function CaptureMS(strFileName) {
        return strFileName.replace(PetPhotoTag.EXT, '').split('_')[1] || '';
    }
    PetPhotoTag.CaptureMS = CaptureMS;
    function Aspect(strFileName) {
        const aFound = PetPhotoTag.ASPECTS.filter(row => String(row.id) === Parse(strFileName)['a']);
        return aFound.length > 0 ? aFound[0].ratio : 1;
    }
    PetPhotoTag.Aspect = Aspect;
    const PLACE_LETTERS = ['k', 'y', 'l', 'x', 'w', 'm'];
    PetPhotoTag.SLOT_UNPLACED = 255;
    function IsBookName(strFileName) {
        return strFileName.indexOf('book_') === 0;
    }
    PetPhotoTag.IsBookName = IsBookName;
    function LibraryFolder(strPetKey) {
        return 'pet/' + strPetKey + '/library';
    }
    PetPhotoTag.LibraryFolder = LibraryFolder;
    function BookFolder(strPetKey) {
        return 'pet/' + strPetKey + '/book';
    }
    PetPhotoTag.BookFolder = BookFolder;
    function PhotoUrl(strPetKey, strFileName) {
        return 'file://{pet}/' + strPetKey + (IsBookName(strFileName) ? '/book/' : '/library/') + strFileName;
    }
    PetPhotoTag.PhotoUrl = PhotoUrl;
    function PlaceOf(strFileName) {
        const fields = Parse(strFileName);
        const nPage = Number(fields['k']);
        const nLayout = Number(fields['y']);
        const nSlot = Number(fields['l']);
        if (isNaN(nPage) || isNaN(nLayout) || isNaN(nSlot)) {
            return undefined;
        }
        return { page: nPage, layout: nLayout, slot: nSlot };
    }
    PetPhotoTag.PlaceOf = PlaceOf;
    PetPhotoTag.FRAME_DEFAULT = { x: 50, y: 50, zoom: 100 };
    PetPhotoTag.FRAME_ZOOM_MAX = 300;
    function _Clamp(n, min, max) {
        return isNaN(n) ? min : Math.max(min, Math.min(max, Math.round(n)));
    }
    function FrameOf(strFileName) {
        const fields = Parse(strFileName);
        return {
            x: fields['x'] === undefined ? PetPhotoTag.FRAME_DEFAULT.x : _Clamp(Number(fields['x']), 0, 100),
            y: fields['w'] === undefined ? PetPhotoTag.FRAME_DEFAULT.y : _Clamp(Number(fields['w']), 0, 100),
            zoom: fields['m'] === undefined ? PetPhotoTag.FRAME_DEFAULT.zoom : _Clamp(Number(fields['m']), 100, PetPhotoTag.FRAME_ZOOM_MAX),
        };
    }
    PetPhotoTag.FrameOf = FrameOf;
    function IsDefaultFrame(frame) {
        return frame.x === PetPhotoTag.FRAME_DEFAULT.x && frame.y === PetPhotoTag.FRAME_DEFAULT.y && frame.zoom === PetPhotoTag.FRAME_DEFAULT.zoom;
    }
    PetPhotoTag.IsDefaultFrame = IsDefaultFrame;
    function _FrameFields(frame) {
        return IsDefaultFrame(frame) ? '' :
            '_x' + _Clamp(frame.x, 0, 100) +
                '_w' + _Clamp(frame.y, 0, 100) +
                '_m' + _Clamp(frame.zoom, 100, PetPhotoTag.FRAME_ZOOM_MAX);
    }
    function WithFrame(strFileName, frame) {
        const place = PlaceOf(strFileName);
        return place === undefined ? strFileName : BookName(strFileName, place, frame);
    }
    PetPhotoTag.WithFrame = WithFrame;
    function _Stem(strFileName) {
        const aTokens = strFileName.replace(PetPhotoTag.EXT, '').split('_');
        const aFields = aTokens.filter((strToken, i) => i >= 2 && PLACE_LETTERS.indexOf(strToken.charAt(0)) < 0);
        return aFields.length === 0 ? aTokens[1] : aTokens[1] + '_' + aFields.join('_');
    }
    function RollName(strFileName) {
        return 'pet_' + _Stem(strFileName) + PetPhotoTag.EXT;
    }
    PetPhotoTag.RollName = RollName;
    function BookName(strFileName, place, frame) {
        return 'book_' + _Stem(strFileName) +
            '_k' + place.page + '_y' + place.layout + '_l' + place.slot +
            _FrameFields(frame === undefined ? PetPhotoTag.FRAME_DEFAULT : frame) + PetPhotoTag.EXT;
    }
    PetPhotoTag.BookName = BookName;
    function _LetterIndex() {
        const byLetter = {};
        FIELDS.forEach(field => { byLetter[field.letter] = field; });
        return byLetter;
    }
    const BY_LETTER = _LetterIndex();
    function _Word(field, strHas) {
        if (field.codes) {
            const aFound = field.codes.filter(value => value.id === Number(strHas));
            return aFound.length > 0 ? aFound[0].name : strHas;
        }
        if (field.bands) {
            const nHas = Number(strHas);
            const aIn = field.bands.filter(row => nHas >= row.band[0] && nHas <= row.band[1]);
            return aIn.length > 0 ? aIn[0].name : strHas;
        }
        return strHas;
    }
    const DESCRIBE_ORDER = ['g', 'z', 's', 'v', 'e', 'f', 'p'];
    function WordFor(strLetter, strValue) {
        const field = BY_LETTER[strLetter];
        return field === undefined ? strValue : _NameWord(strLetter, _Word(field, strValue));
    }
    PetPhotoTag.WordFor = WordFor;
    function Describe(strFileName) {
        const fields = Parse(strFileName);
        const aLines = [];
        DESCRIBE_ORDER.forEach(strLetter => {
            const field = BY_LETTER[strLetter];
            const strHas = fields[strLetter];
            if (field !== undefined && field.caption !== undefined && strHas !== undefined) {
                aLines.push($.Localize(field.caption) + ': <b>' + WordFor(strLetter, strHas) + '</b>');
            }
        });
        return aLines.join('<br>');
    }
    PetPhotoTag.Describe = Describe;
    function _Satisfies(field, strName, strHas, strAsked) {
        if (field.bands) {
            const aBand = field.bands.filter(row => row.name === strAsked);
            if (aBand.length === 0) {
                return true;
            }
            const nHas = Number(strHas);
            return nHas >= aBand[0].band[0] && nHas <= aBand[0].band[1];
        }
        if (field.codes) {
            const strWanted = _IdOf(field.codes, strAsked);
            if (strWanted === '') {
                return true;
            }
            return strHas === strWanted;
        }
        return strHas === strAsked;
    }
    function _Terms(strRequire) {
        if (strRequire === '') {
            return [];
        }
        const aTerms = [];
        strRequire.split(',').forEach(strTerm => {
            const aParts = strTerm.split(':');
            const field = REQUIRE[aParts[0]];
            if (aParts.length !== 2 || field === undefined) {
                return;
            }
            aTerms.push({ name: aParts[0], field: field, asked: aParts[1].split('|') });
        });
        return aTerms;
    }
    function Unmet(strFileName, strRequire) {
        const fields = Parse(strFileName);
        function bHolds(term) {
            const strHas = fields[term.field.letter];
            return strHas !== undefined &&
                term.asked.some(strAsked => _Satisfies(term.field, term.name, strHas, strAsked));
        }
        return _Terms(strRequire).filter(term => !bHolds(term)).map(term => term.name);
    }
    PetPhotoTag.Unmet = Unmet;
    function Matches(strFileName, strRequire) {
        return Unmet(strFileName, strRequire).length === 0;
    }
    PetPhotoTag.Matches = Matches;
    function _NameWord(strLetter, strName) {
        const field = BY_LETTER[strLetter];
        if (field === undefined) {
            return strName;
        }
        const aValues = field.codes || field.bands || field.words || [];
        const aFound = aValues.filter(value => value.name === strName);
        if (aFound.length === 0) {
            return strName;
        }
        if (field.loc !== undefined) {
            return $.Localize(field.loc + strName);
        }
        const strWord = aFound[0].word || strName;
        return strWord.charAt(0) === '#' ? $.Localize(strWord) : strWord;
    }
    function TermWords(strRequire) {
        return _Terms(strRequire).map(term => ({
            name: term.name,
            word: term.asked.map(strAsked => _InlineWord(term.field, strAsked)).join(' or '),
        }));
    }
    PetPhotoTag.TermWords = TermWords;
    function _InlineWord(field, strName) {
        const strInline = field.loc === undefined ? '' : field.loc + strName + '_inline';
        return (strInline !== '' && $.CanLocalize(strInline)) ?
            $.Localize(strInline) : _NameWord(field.letter, strName);
    }
})(PetPhotoTag || (PetPhotoTag = {}));
