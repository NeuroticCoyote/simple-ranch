%%%-------------------------------------------------------------------
%% @doc simple-ranch public API
%% @end
%%%-------------------------------------------------------------------

-module(simple_ranch_app).
-behaviour(application).

-export([start/2, stop/1]).

%=============================
% API
%=============================
start(_StartType, _StartArgs) ->
    lager:start(),
    {ok, _} = application:ensure_all_started(ranch),
    {ok, Port} = application:get_env(simple_ranch, tcp_port),
    ranch:start_listener(tcp_handler, ranch_tcp, [{port, Port}], tcp_handler, []).

stop(_State) ->
    ok.