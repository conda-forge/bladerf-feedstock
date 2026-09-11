setlocal EnableDelayedExpansion
@echo on

mkdir build
cd build

:: configure
cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_LIBDIR=lib ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DBUILD_DOCUMENTATION=OFF ^
    -DBUNDLE_EXTERNAL_LIBRARIES=OFF ^
    -DENABLE_BACKEND_LIBUSB=ON ^
    -DENABLE_BACKEND_CYAPI=OFF ^
    -DENABLE_BACKEND_DUMMY=OFF ^
    -DENABLE_FX3_BUILD=OFF ^
    -DENABLE_HOST_BUILD=ON ^
    -DENABLE_LIBTECLA=OFF ^
    -DINSTALL_UDEV_RULES=OFF ^
    -DTAGGED_RELEASE=ON ^
    -DTEST_LIBBLADERF=OFF ^
    -DTREAT_WARNINGS_AS_ERRORS=OFF ^
    -DLIBPTHREADSWIN32_PATH="%LIBRARY_PREFIX%" ^
    -DLIBPTHREADSWIN32_LIBRARIES="%LIBRARY_LIB%\pthread.lib" ^
    -DLIBPTHREADSWIN32_DLL="%LIBRARY_LIB%\pthread.lib" ^
    -DLIBUSB_SKIP_VERSION_CHECK=ON ^
    ..
if errorlevel 1 exit 1

:: build
cmake --build . --config Release -- -j%CPU_COUNT%
if errorlevel 1 exit 1

:: install
cmake --build . --config Release --target install
if errorlevel 1 exit 1
:: move dll to proper location
cmake -E rename %LIBRARY_PREFIX%\lib\bladeRF-2.dll %LIBRARY_PREFIX%\bin\bladeRF-2.dll
if errorlevel 1 exit 1
:: move cmake modules to proper location
cmake -E copy_directory %LIBRARY_PREFIX%\cmake %LIBRARY_PREFIX%\share\cmake\bladeRF
if errorlevel 1 exit 1
cmake -E rm -rf %LIBRARY_PREFIX%\cmake
if errorlevel 1 exit 1
