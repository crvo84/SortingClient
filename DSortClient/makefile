all:commonprefix



clean:
	rm *.o urlchanger

CC=clang
CFLAGS+=-O0 -g
CXXFLAGS+=-O0 -g
#LDFLAGS+=-macosx_version_min 10.6

urlchanger:urlchanger.o
	$(CC) $< $(LDFLAGS)  -F/System/Library/Frameworks -framework Foundation -o $@

fileattributes:fileattributes.o
	$(CC) $< $(LDFLAGS)  -F/System/Library/Frameworks -framework Foundation -framework AppKit -o $@

commonprefix:commonprefix.mm.o
	$(CC) $< $(LDFLAGS) -ObjC++ -stdlib=libstdc++  -F/System/Library/Frameworks -framework Foundation -framework AppKit -o $@ -lstdc++


############################################################
####################
# Rules
############################################################
####################
%.c.o : %.c $(C_DEPS)
	$(VERBOSE)$(CC) $(CFLAGS) -o $@ -c $<

%.cpp.o : %.cpp $(C_DEPS)
	$(VERBOSE)$(CXX) $(CXXFLAGS) -o $@ -c $<

%.m.o : %.m $(C_DEPS)
	$(VERBOSE)$(CXX) $(CFLAGS) -o $@ -c $<

%.mm.o : %.mm $(C_DEPS)
	$(VERBOSE)$(CXX) $(CXXFLAGS) -o $@ -c $<
