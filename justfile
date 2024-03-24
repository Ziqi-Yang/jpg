import 'jpg.just'

@_check-deps:
    echo All the dependencies are optional. But some helper command of jpg use these \
      dependencies.
    echo ======================================
    -type sd
    -type fd
    echo ======================================
    echo sd - https://github.com/chmln/sd
    echo fd - https://github.com/sharkdp/fd

intall_completion:

# Install jpg
install: && _check-deps
    #TODO

test: && (jpg-replace-basic "test")
    rm -rf ./test
    cp -r ./test_template ./test
    

    
    

