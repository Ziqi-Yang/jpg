import 'mpm.just'

@_check-deps:
    echo All the dependencies are optional. But some helper command of mpm use these \
      dependencies.
    echo ======================================
    -type sd
    -type fd
    echo ======================================
    echo sd - https://github.com/chmln/sd
    echo fd - https://github.com/sharkdp/fd

intall_completion:

# Install mpm
install: && _check-deps
    #TODO

test: && (mpm-replace-basic "test")
    rm -rf ./test
    cp -r ./test_template ./test
    

    
    

