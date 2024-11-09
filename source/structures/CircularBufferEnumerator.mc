import Toybox.Lang;

class CircularBufferEnumerator {

    private var _buffer as CircularBuffer;
    private var _current as Lang.Number;

    public function initialize(buffer as CircularBuffer) {
        _buffer = buffer;
        _current = buffer.getIndex();
    }

    public function next() {
        
    }

}