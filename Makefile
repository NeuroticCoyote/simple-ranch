clean:
	rm -rf _build
	rm -rf log
	rebar3 clean

shell:
	rebar3 compile
	rebar3 shell
