<<<<<<< HEAD
#!/usr/bin/env make -f
# GIfTI Makefile
#
# Copyright (C) 2015 Wellcome Trust Centre for Neuroimaging
#
# $Id: Makefile 6704 2016-01-29 17:23:13Z guillaume $

include Makefile.var

SPMMEX = zstream.$(SUF) xml_parser.$(SUF) base64.$(SUF)

ifeq (mex,$(SUF))
  export CFLAGS = $(shell $(MEX) -p CFLAGS) -std=c99
else
  ifeq (windows,$(PLATFORM))
    MEXOPTS += CFLAGS=\"$$CFLAGS -std=c99\"
  else
    MEXOPTS += CFLAGS='$$CFLAGS -std=c99'
  endif
endif

all: $(SPMMEX)
	@:

clean:
	@:
        
distclean: clean
	$(DEL) $(SPMMEX)

install:
	@:

tarball: all
	$(TAR) cf spm_mex.tar $(SPMMEX)

%.$(SUF) : %.c
	$(MEX) $< $(MEXEND)

xml_parser.$(SUF): xml_parser.c yxml.c yxml.h
	$(MEX) $< yxml.c $(MEXEND)
=======
#!/usr/bin/env make -f
# GIfTI Makefile
#
# Copyright (C) 2015 Wellcome Trust Centre for Neuroimaging
#
# $Id: Makefile 6704 2016-01-29 17:23:13Z guillaume $

include Makefile.var

SPMMEX = zstream.$(SUF) xml_parser.$(SUF) base64.$(SUF)

ifeq (mex,$(SUF))
  export CFLAGS = $(shell $(MEX) -p CFLAGS) -std=c99
else
  ifeq (windows,$(PLATFORM))
    MEXOPTS += CFLAGS=\"$$CFLAGS -std=c99\"
  else
    MEXOPTS += CFLAGS='$$CFLAGS -std=c99'
  endif
endif

all: $(SPMMEX)
	@:

clean:
	@:
        
distclean: clean
	$(DEL) $(SPMMEX)

install:
	@:

tarball: all
	$(TAR) cf spm_mex.tar $(SPMMEX)

%.$(SUF) : %.c
	$(MEX) $< $(MEXEND)

xml_parser.$(SUF): xml_parser.c yxml.c yxml.h
	$(MEX) $< yxml.c $(MEXEND)
>>>>>>> 4de96d76c3932df0b65301ef0a8db73e89bc5fa6
