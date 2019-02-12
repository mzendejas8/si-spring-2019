
# GTest configuration
GTEST_DIR = googletest
GTEST_LIB_DIR = googletest/build
GTEST_LIBS = libgtest.a libgtest_main.a
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
                $(GTEST_DIR)/include/gtest/internal/*.h
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

# Flags passed to the preprocessor & compiler
CPPFLAGS += -isystem $(GTEST_DIR)/include
CXXFLAGS += -g -Wall -Wextra -pthread -std=c++11

# Test(s) produces by this makefile
TESTS = test

# House-keeping build targets
all : $(GTEST_LIBS) $(TESTS)

clean :
	rm -rf $(GTEST_LIBS) $(TESTS) *.o *.dSYM

# Builds gtest.a and gtest_main.a
gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
            $(GTEST_DIR)/src/gtest-all.cc

gtest_main.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
            $(GTEST_DIR)/src/gtest_main.cc

libgtest.a : gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

libgtest_main.a : gtest-all.o gtest_main.o
	$(AR) $(ARFLAGS) $@ $^


# Build source files and test
DIRS = 1-dynamic-memory
SRCS = $(patsubst %, %/src/*.cpp, $(DIRS))
INC_PATH = $(patsubst %, -I%/include, $(DIRS)) $(patsubst %, -I%, $(DIRS))

$(info $$INC_PATH is [${INC_PATH}])

test : test.cpp $(SRCS) $(GTEST_LIBS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(INC_PATH) -L$(GTEST_LIB_DIR) -lgtest_main -lpthread $^ -o $@

