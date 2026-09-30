"use strict";

var watchEventLiveExample_01 = "";
var watchEventLiveExample_02 = "";
var watchEventLiveExample_03 = "";
var teamExample = "";

var ADD_DEBUG_EVENT = "0";

//DEVONLY{
ADD_DEBUG_EVENT = GameInterfaceAPI.GetSettingString(
  "ui_eventschedule_debug_example"
);

if (ADD_DEBUG_EVENT == "1") {
  watchEventLiveExample_01 = {
    event_id: "01",
    name: "favorite",
    logo_url:
      "https://cdn.beta.steampowered.com/apps/730/resource/hltv/7d/42/eee1d50eacbc284fc0791933a5a484bedc0e.png",
    flag_url:
      "https://cdn.beta.steampowered.com/apps/730/resource/hltv/2f/a8/d027c2a8b63c847ec53659b2940b97fa50cd.png",
    start_date_time: { seconds: 1542835800, nanos: 0 },
    end_date_time: { seconds: 1543057200, nanos: 0 },
    state: "Live",
    match_location: "ONLINE",
    event_page_url:
      "https://www.hltv.org/events/4230/esea-open-season-29-brazil",
    live_matches: [
      {
        match_id: "2329357",
        team1_name: "Fusion",
        team2_name: "W7M",
        team1_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/09/12/c09f4f50c916382c92da450aef2f9d58291e.png",
        team2_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/36/47/2f8de4f262695131c84ccd75644e010a23bb.png",
        streams: [
          {
            stream_id: "2887",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=hitmediaru2&parent=www.valvesoftware.comf",
            iso: "ru",
          },
        ],
        match_page_url:
          "https://www.hltv.org/matches/2329357/fusion-vs-w7m-esea-open-season-29-brazil&parent=www.valvesoftware.comf",
      },
    ],
    teams: [
      {
        name: "Furious",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/0b/37/0d87a5b03083a37d6e925225ef0dcfb048e4.png",
      },
      {
        name: "Rejected",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/73/ca/342a9486328e094eb893895a07993c1a0490.png",
      },
      {
        name: "Isurus",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/45/73/3204da6d93ac6d44a99cd1d0d71ba68d26e7.png",
      },
      {
        name: "Sharks",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/1d/99/19ce9d50e89612b29e786f6aaefef96579a6.png",
      },
      {
        name: "W7M",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/36/47/2f8de4f262695131c84ccd75644e010a23bb.png",
      },
      {
        name: "FURIA Inagame",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/0f/a1/717d545703bdf9054bc4fbb45241075956e3.png",
      },
      {
        name: "Wild",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/7e/8f/54d62612cb8e22709e0c65a7736d834ddc43.png",
      },
      {
        name: "DETONA",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/c6/a5/95c2fb828632114adf61bc24574c3bdb0321.png",
      },
      {
        name: "Bulldozer",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/b9/72/a97e903de56042721d2e9f755dd52b91e0a3.png",
      },
      {
        name: "WePlayGames",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/43/b9/8582df74e3cdad33c3a387c6ba5ad393f64d.png",
      },
      {
        name: "Imperial",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/ca/08/7450751e5c5bbeeec5e28d3f7875222522ed.png",
      },
      {
        name: "Fusion",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/09/12/c09f4f50c916382c92da450aef2f9d58291e.png",
      },
      {
        name: "Turma do Pagode",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/a4/2a/45f8bbf099aab2497858b25b22766759a1fb.png",
      },
      {
        name: "MAFiA",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/f9/05/86a403a5dd94dfb83769484b083d2b0776ec.png",
      },
      {
        name: "Respeito",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/f9/05/86a403a5dd94dfb83769484b083d2b0776ec.png",
      },
      {
        name: "HARDNEJA",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/f9/05/86a403a5dd94dfb83769484b083d2b0776ec.png",
      },
    ],
    country_iso: "br",
    prize_description: "2500",
  };
  watchEventLiveExample_02 = {
    event_id: "02",
    name: "featured",
    is_featured: true,
    logo_url:
      "https://cdn.beta.steampowered.com/apps/730/resource/hltv/7d/42/eee1d50eacbc284fc0791933a5a484bedc0e.png",
    flag_url:
      "https://cdn.beta.steampowered.com/apps/730/resource/hltv/2f/a8/d027c2a8b63c847ec53659b2940b97fa50cd.png",
    start_date_time: { seconds: 1542835800, nanos: 0 },
    end_date_time: { seconds: 1543057200, nanos: 0 },
    state: "Live",
    match_location: "ONLINE",
    event_page_url:
      "https://www.hltv.org/events/4230/esea-open-season-29-brazil",
    live_matches: [
      {
        match_id: "2329356",
        team1_name: "FURIA Inagame",
        team2_name: "WePlayGames",
        team1_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/0f/a1/717d545703bdf9054bc4fbb45241075956e3.png",
        team2_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/43/b9/8582df74e3cdad33c3a387c6ba5ad393f64d.png",
        streams: [],
        match_page_url:
          "https://www.hltv.org/matches/2329356/furia-inagame-vs-weplaygames-esea-open-season-29-brazil&parent=www.valvesoftware.comf",
      },
      {
        match_id: "2329357",
        team1_name: "Fusion",
        team2_name: "W7M",
        team1_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/09/12/c09f4f50c916382c92da450aef2f9d58291e.png",
        team2_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/36/47/2f8de4f262695131c84ccd75644e010a23bb.png",
        streams: [
          {
            stream_id: "2887",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=hitmediaru2&parent=www.valvesoftware.com",
            iso: "ru",
          },
        ],
        match_page_url:
          "https://www.hltv.org/matches/2329357/fusion-vs-w7m-esea-open-season-29-brazil&parent=www.valvesoftware.comf",
      },
    ],
    teams: [
      {
        name: "Furious",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/0b/37/0d87a5b03083a37d6e925225ef0dcfb048e4.png",
      },
      {
        name: "Rejected",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/73/ca/342a9486328e094eb893895a07993c1a0490.png",
      },
      {
        name: "Isurus",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/45/73/3204da6d93ac6d44a99cd1d0d71ba68d26e7.png",
      },
      {
        name: "Sharks",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/1d/99/19ce9d50e89612b29e786f6aaefef96579a6.png",
      },
      {
        name: "W7M",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/36/47/2f8de4f262695131c84ccd75644e010a23bb.png",
      },
      {
        name: "FURIA Inagame",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/0f/a1/717d545703bdf9054bc4fbb45241075956e3.png",
      },
      {
        name: "Wild",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/7e/8f/54d62612cb8e22709e0c65a7736d834ddc43.png",
      },
      {
        name: "DETONA",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/c6/a5/95c2fb828632114adf61bc24574c3bdb0321.png",
      },
      {
        name: "Bulldozer",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/b9/72/a97e903de56042721d2e9f755dd52b91e0a3.png",
      },
      {
        name: "WePlayGames",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/43/b9/8582df74e3cdad33c3a387c6ba5ad393f64d.png",
      },
      {
        name: "Imperial",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/ca/08/7450751e5c5bbeeec5e28d3f7875222522ed.png",
      },
      {
        name: "Fusion",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/09/12/c09f4f50c916382c92da450aef2f9d58291e.png",
      },
      {
        name: "Turma do Pagode",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/a4/2a/45f8bbf099aab2497858b25b22766759a1fb.png",
      },
      {
        name: "MAFiA",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/f9/05/86a403a5dd94dfb83769484b083d2b0776ec.png",
      },
      {
        name: "Respeito",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/f9/05/86a403a5dd94dfb83769484b083d2b0776ec.png",
      },
      {
        name: "HARDNEJA",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/f9/05/86a403a5dd94dfb83769484b083d2b0776ec.png",
      },
    ],
    country_iso: "br",
    prize_description: "2500",
  };
  watchEventLiveExample_03 = {
    event_id: "03",
    name: "official",
    is_official: true,
    logo_url:
      "https://cdn.beta.steampowered.com/apps/730/resource/hltv/7d/42/eee1d50eacbc284fc0791933a5a484bedc0e.png",
    flag_url:
      "https://cdn.beta.steampowered.com/apps/730/resource/hltv/2f/a8/d027c2a8b63c847ec53659b2940b97fa50cd.png",
    start_date_time: { seconds: 1542835800, nanos: 0 },
    end_date_time: { seconds: 1543057200, nanos: 0 },
    state: "Live",
    match_location: "ONLINE",
    event_page_url:
      "https://www.hltv.org/events/4230/esea-open-season-29-brazil",
    live_matches: [
      {
        match_id: "2329349",
        team1_name: "DETONA",
        team2_name: "Turma do Pagode",
        team1_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/c6/a5/95c2fb828632114adf61bc24574c3bdb0321.png",
        team2_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/a4/2a/45f8bbf099aab2497858b25b22766759a1fb.png",
        streams: [
          {
            stream_id: "33",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=starladder5&parent=www.valvesoftware.com",
            iso: "ru",
          },
          {
            stream_id: "157",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=99damage&parent=www.valvesoftware.com",
            iso: "de",
          },
          {
            stream_id: "533",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=izakooo&parent=www.valvesoftware.com",
            iso: "pl",
          },
          {
            stream_id: "1251",
            site: "TWITCH",
            resolved_embed:
              "https://player.twitch.tv/?channel=starladder_cs_en&parent=www.valvesoftware.com",
            iso: "gb",
          },
          {
            stream_id: "1570",
            site: "TWITCH",
            resolved_embed:
              "https://player.twitch.tv/?channel=starladder_cs_pt&parent=www.valvesoftware.com",
            iso: "br",
            language: "pt"
          },
          {
            stream_id: "2265",
            site: "YOUTUBEAUTO",
            resolved_embed:
              "https://www.youtube.com/embed/ReHNDLdGUps?autoplay=1",
            iso: "ro",
          },
          {
            stream_id: "2289",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=pituherranz&parent=www.valvesoftware.com",
            iso: "es",
          },
          {
            stream_id: "2413",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=1pvcs&parent=www.valvesoftware.com",
            iso: "fr",
          },
          {
            stream_id: "2429",
            site: "YOUTUBE",
            resolved_embed:
              "https://www.youtube.com/embed/uWpYNNOSRh8?autoplay=1",
            iso: "vn",
          },
          {
            stream_id: "2478",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=metabro&parent=www.valvesoftware.com",
            iso: "hu",
          },
          {
            stream_id: "2509",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=rtparenacsgo&parent=www.valvesoftware.com",
            iso: "pt",
          },
          {
            stream_id: "2597",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=FURIAtv&parent=www.valvesoftware.com",
            iso: "br",
            language: "pt"
          },
          {
            stream_id: "2617",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=devilgamintv&parent=www.valvesoftware.com",
            iso: "lb",
          },
          {
            stream_id: "2654",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=gaules&parent=www.valvesoftware.com",
            iso: "br",
            language: "pt"
          },
          {
            stream_id: "2817",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=rootthegamer&parent=www.valvesoftware.com",
            iso: "tr",
          },
          {
            stream_id: "2910",
            site: "TWITCH",
            resolved_embed:
              "https://player.twitch.tv/?channel=richardlewisreports&parent=www.valvesoftware.com",
            iso: "gb",
            language: "en" 
          },
          {
            stream_id: "2921",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=mch_AGG&parent=www.valvesoftware.com",
            iso: "br",
            language: "pt"
          },
          {
            stream_id: "3052",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=missclick_tv&parent=www.valvesoftware.com",
            iso: "br",
            language: "pt"
          },
          {
            stream_id: "3130",
            site: "YOUTUBE",
            resolved_embed:
              "https://www.youtube.com/embed/Ly-FA1DWBBo?autoplay=1",
            iso: "br",
          },
          {
            stream_id: "3162",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=pelaajatcom&parent=www.valvesoftware.com",
            iso: "world",
          },
          {
            stream_id: "3205",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=tes_csgo&parent=www.valvesoftware.com",
            iso: "fi",
          },
          {
            stream_id: "3213",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=peek_latam&parent=www.valvesoftware.com",
            iso: "ar",
          },
          {
            stream_id: "3237",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=fulcral&parent=www.valvesoftware.com",
            iso: "br",
            language: "pt"
          },
          {
            stream_id: "3237",
            site: "GOTV",
            resolved_embed: "https://gotv.pglesports.com/match/id/major",
            iso: "br",
            language: "pt"
          },
          {
            stream_id: "3281",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=Neytrex&parent=www.valvesoftware.com",
            iso: "bg",
          },
        ],
        match_page_url:
          "https://www.hltv.org/matches/2329349/detona-vs-turma-do-pagode-esea-open-season-29-brazil&parent=www.valvesoftware.comf",
      },
      {
        match_id: "2329350",
        team1_name: "Rejected",
        team2_name: "Bulldozer",
        team1_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/73/ca/342a9486328e094eb893895a07993c1a0490.png",
        team2_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/b9/72/a97e903de56042721d2e9f755dd52b91e0a3.png",
        streams: [
          {
            stream_id: "2155",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=sanman67&parent=www.valvesoftware.com",
            iso: "ru",
          },
        ],
        match_page_url:
          "https://www.hltv.org/matches/2329350/rejected-vs-bulldozer-esea-open-season-29-brazil&parent=www.valvesoftware.comf",
      },
      {
        match_id: "2329356",
        team1_name: "FURIA Inagame",
        team2_name: "WePlayGames",
        team1_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/0f/a1/717d545703bdf9054bc4fbb45241075956e3.png",
        team2_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/43/b9/8582df74e3cdad33c3a387c6ba5ad393f64d.png",
        streams: [],
        match_page_url:
          "https://www.hltv.org/matches/2329356/furia-inagame-vs-weplaygames-esea-open-season-29-brazil",
      },
      {
        match_id: "2329357",
        team1_name: "Fusion",
        team2_name: "W7M",
        team1_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/09/12/c09f4f50c916382c92da450aef2f9d58291e.png",
        team2_logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/36/47/2f8de4f262695131c84ccd75644e010a23bb.png",
        streams: [
          {
            stream_id: "2887",
            site: "TWITCH",
            resolved_embed: "https://player.twitch.tv/?channel=hitmediaru2&parent=www.valvesoftware.com",
            iso: "ru",
          },
        ],
        match_page_url:
          "https://www.hltv.org/matches/2329357/fusion-vs-w7m-esea-open-season-29-brazil&parent=www.valvesoftware.comf",
      },
    ],
    teams: [
      {
        name: "Furious",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/0b/37/0d87a5b03083a37d6e925225ef0dcfb048e4.png",
      },
      {
        name: "Rejected",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/73/ca/342a9486328e094eb893895a07993c1a0490.png",
      },
      {
        name: "Isurus",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/45/73/3204da6d93ac6d44a99cd1d0d71ba68d26e7.png",
      },
      {
        name: "Sharks",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/1d/99/19ce9d50e89612b29e786f6aaefef96579a6.png",
      },
      {
        name: "W7M",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/36/47/2f8de4f262695131c84ccd75644e010a23bb.png",
      },
      {
        name: "FURIA Inagame",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/0f/a1/717d545703bdf9054bc4fbb45241075956e3.png",
      },
      {
        name: "Wild",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/7e/8f/54d62612cb8e22709e0c65a7736d834ddc43.png",
      },
      {
        name: "DETONA",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/c6/a5/95c2fb828632114adf61bc24574c3bdb0321.png",
      },
      {
        name: "Bulldozer",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/b9/72/a97e903de56042721d2e9f755dd52b91e0a3.png",
      },
      {
        name: "WePlayGames",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/43/b9/8582df74e3cdad33c3a387c6ba5ad393f64d.png",
      },
      {
        name: "Imperial",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/ca/08/7450751e5c5bbeeec5e28d3f7875222522ed.png",
      },
      {
        name: "Fusion",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/09/12/c09f4f50c916382c92da450aef2f9d58291e.png",
      },
      {
        name: "Turma do Pagode",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/a4/2a/45f8bbf099aab2497858b25b22766759a1fb.png",
      },
      {
        name: "MAFiA",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/f9/05/86a403a5dd94dfb83769484b083d2b0776ec.png",
      },
      {
        name: "Respeito",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/f9/05/86a403a5dd94dfb83769484b083d2b0776ec.png",
      },
      {
        name: "HARDNEJA",
        logo_url:
          "https://cdn.beta.steampowered.com/apps/730/resource/hltv/f9/05/86a403a5dd94dfb83769484b083d2b0776ec.png",
      },
    ],
    country_iso: "br",
    prize_description: "2500",
  };

  teamExample = {
    name: "Astralis",
    logo_url: "https://static.hltv.org/images/team/logo/6665",
    link: "https://www.hltv.org/team/6665/astralis",
    lineup: [
      {
        nickname: "Xyp9x",
        realname: "Andreas Højsleth",
        bodyshot_url:
          "https://static.hltv.org/images/playerprofile/bodyshot/compressed/4954.png",
        profile_photo_url: {
          resource:
            "https://static.hltv.org/images/playerprofile/thumb/4954/400.jpeg?v\u003d6",
          player_name: "Andreas \u0027Xyp9x\u0027 Højsleth",
        },
        age: 23,
        profile_url: "https://www.hltv.org/player/4954/Xyp9x",
      },
      {
        nickname: "dupreeh",
        realname: "Peter Rasmussen",
        bodyshot_url:
          "https://static.hltv.org/images/playerprofile/bodyshot/compressed/7398.png",
        profile_photo_url: {
          resource:
            "https://static.hltv.org/images/playerprofile/thumb/7398/400.jpeg?v\u003d6",
          player_name: "Peter \u0027dupreeh\u0027 Rasmussen",
        },
        age: 25,
        profile_url: "https://www.hltv.org/player/7398/dupreeh",
      },
      {
        nickname: "gla1ve",
        realname: "Lukas Rossander",
        bodyshot_url:
          "https://static.hltv.org/images/playerprofile/bodyshot/compressed/7412.png",
        profile_photo_url: {
          resource:
            "https://static.hltv.org/images/playerprofile/thumb/7412/400.jpeg?v\u003d8",
          player_name: "Lukas \u0027gla1ve\u0027 Rossander",
        },
        age: 23,
        profile_url: "https://www.hltv.org/player/7412/gla1ve",
      },
      {
        nickname: "device",
        realname: "Nicolai Reedtz",
        bodyshot_url:
          "https://static.hltv.org/images/playerprofile/bodyshot/compressed/7592.png",
        profile_photo_url: {
          resource:
            "https://static.hltv.org/images/playerprofile/thumb/7592/400.jpeg?v\u003d8",
          player_name: "Nicolai \u0027device\u0027 Reedtz",
        },
        age: 23,
        profile_url: "https://www.hltv.org/player/7592/device",
      },
      {
        nickname: "Magisk",
        realname: "Emil Reif",
        bodyshot_url:
          "https://static.hltv.org/images/playerprofile/bodyshot/compressed/9032.png",
        profile_photo_url: {
          resource:
            "https://static.hltv.org/images/playerprofile/thumb/9032/400.jpeg?v\u003d12",
          player_name: "Emil \u0027Magisk\u0027 Reif",
        },
        age: 20,
        profile_url: "https://www.hltv.org/player/9032/Magisk",
      },
    ],
  };
}
//}DEVONLY
