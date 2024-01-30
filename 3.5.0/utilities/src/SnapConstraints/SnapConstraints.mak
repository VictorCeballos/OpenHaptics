# Makefile - SnapConstraints

ifndef include_dir
include_dir = /usr/include
endif

ifndef libsrc_dir
libsrc_dir = /usr/share/3DTouch/libsrc
endif

ifndef libdir
libdir = /usr/lib
endif

#DEBUG = TRUE

ifdef DEBUG
CFG=SnapConstraints_DEBUG
else
CFG=SnapConstraints_RELEASE
endif

CC=gcc
CFLAGS=
CXX=g++
CXXFLAGS=$(CFLAGS)

INCLUDES = -I../../../include -I../../include

ifeq "$(CFG)"  "SnapConstraints_RELEASE"
CFLAGS+=-W -fexceptions -O2 $(INCLUDES) -Dlinux -DNDEBUG -fPIC
AR=ar
ARFLAGS=rus
else

ifeq "$(CFG)"  "SnapConstraints_DEBUG"
CFLAGS+=-W -fexceptions -g -O0 $(INCLUDES) -Dlinux -D_DEBUG -fPIC
AR=ar
TARGET=SnapConstraintsD
ARFLAGS=rus
endif
endif

ifndef TARGET
TARGET=SnapConstraints
endif

TARGET_LIB := $(addprefix lib,$(TARGET))
TARGET_LIB := $(addprefix ../../lib/,$(TARGET_LIB))
TARGET_LIB := $(addsuffix .a,$(TARGET_LIB))

.PHONY: all
all: $(TARGET_LIB)

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

%.o: %.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ -c $<

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ -c $<

%.o: %.cxx
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ -c $<

SOURCE_FILES= \
	src/CompositeConstraint.cpp \
	src/ConstraintHolder.cpp \
	src/LineConstraint.cpp \
	src/PlaneConstraint.cpp \
	src/PointConstraint.cpp \
	src/SnapConstraint.cpp \
	src/SnapConstraintsAfx.cpp \
	src/SnapConstraintsAPI.cpp

PUBLIC_HEADER_FILES= \
	../../include/SnapConstraints/CompositeConstraint.h \
	../../include/SnapConstraints/ConstraintHolder.h \
	../../include/SnapConstraints/ISnapConstraintsAPI.h \
	../../include/SnapConstraints/LineConstraint.h \
	../../include/SnapConstraints/PlaneConstraint.h \
	../../include/SnapConstraints/PointConstraint.h \
	../../include/SnapConstraints/SnapConstraint.h \
	../../include/SnapConstraints/StickToConstraint.h

PRIVATE_HEADER_FILES= \
	src/SnapConstraintsAfx.h

SRCS=$(SOURCE_FILES)

OBJS=$(patsubst %.rc,%.res,$(patsubst %.cxx,%.o,$(patsubst %.cpp,%.o,$(patsubst %.cc,%.o,$(patsubst %.c,%.o,$(filter %.c %.cc %.cpp %.cxx %.rc,$(SRCS)))))))

$(TARGET_LIB): $(OBJS) $(PUBLIC_HEADER_FILES) $(PRIVATE_HEADER_FILES)
	$(AR) $(ARFLAGS) $@ $(OBJS)

.PHONY: clean
clean:
	-rm -f $(OBJS) $(TARGET_LIB)

.PHONY: install
install: all
	# copy lib to /usr/lib
	install -m 755 -o 0 -g 0 -d $(libdir)
	install -m 755 -o 0 -g 0 $(TARGET_LIB) $(libdir)
	# copy public header files to /usr/include
	install -m 755 -o 0 -g 0 -d $(include_dir)/$(TARGET)
	install -m 644 -o 0 -g 0 $(PUBLIC_HEADER_FILES) $(include_dir)/$(TARGET)
	# copy private header files and source files to /usr/share/3DTouch/libsrc
	install -m 755 -o 0 -g 0 -d $(libsrc_dir)/$(TARGET)
	install -m 644 -o 0 -g 0 Makefile $(libsrc_dir)/$(TARGET)
	install -m 644 -o 0 -g 0 $(SOURCE_FILES) $(libsrc_dir)/$(TARGET)
	install -m 644 -o 0 -g 0 $(PRIVATE_HEADER_FILES) $(libsrc_dir)/$(TARGET)

