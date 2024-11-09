import Toybox.Lang;

class CircularBufferIterator {

    private var _buffer as CircularBuffer;
    private var _index as Lang.Number;
    private var _size as Lang.Number;

    public function initialize(buffer as CircularBuffer) {
        _buffer = buffer;
        _index = buffer.getIndex();
        _size = buffer.size();
    }

    public function getNext() as Lang.Object {
        var element = _buffer.get(_index);

        _index += 1;
        
        return element;
    }

    public function hasMore() as Lang.Boolean {
        if (_index >= _size) {
            return false;
        } 

        var element = _buffer.get(_index);
    
        if (element == null) {
            return false;
        }

        return true;
    }

    public function reset() as Void {
        _index = 0;
    }

}