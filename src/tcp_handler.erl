-module(tcp_handler).
-behaviour(ranch_protocol).

-compile([{parse_transform, lager_transform}]).

-export([start_link/4]).
-export([init/3]).

%=============================
% API
%=============================
start_link(Ref, _Socket, Transport, Opts) ->
	Pid = spawn_link(?MODULE, init, [Ref, Transport, Opts]),
	{ok, Pid}.

init(Ref, Transport, _Opts) ->
	{ok, Socket} = ranch:handshake(Ref),
	loop(Socket, Transport).

%=============================
% Internal Functions
%=============================
loop(Socket, Transport) ->
	case Transport:recv(Socket, 0, 5000) of
		{ok, Data} when Data =/= <<4>> ->
            lager:info("Received data on tcp handler:~p", [Data]),
			Transport:send(Socket, Data),
			loop(Socket, Transport);
		_ ->
			ok = Transport:close(Socket)
	end.