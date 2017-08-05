#this is a eval func test

PROGRAMS = server client
server_OBJS = server.o server_pri.o server_access.o
server_LIBS = priv protocol

client_OBJS = client.o client_api.o client_mem.o
client_LIBS = protocol

.PHONY:all

define PROGRAM_template
$(1):
	touch $$($(1)_OBJS) $$($(1)_LIBS)
	@echo $$@ " build finished!"
endef

$(foreach prog,$(PROGRAMS),$(eval $(call PROGRAM_template,$(prog))))

$(PROGRAMS):

clean:
	$(RM) *.o $(server_LIBS) $(client_LIBS)
