import Toybox.Lang;

class CircularBuffer {

    private var _size as Number;
    private var _array as Array<Object>;
    private var _index as Number;

    public function initialize(size as Number) {
        _size = size;
        _array = new [size];
        _index = size;
    }

    public function add(item as Object) as Void {
        if (_index == _array.size()) {
            _index = 0;
        }

        _array[_index] = item;
        _index += 1;
    }

    public function get(index as Number) as Object {
        return _array[index];
    }

    public function getLatest() as Object {
        return _array[_index - 1];
    }

    public function size() as Number {
        return _size;
    }

    public function getIndex() as Number {
        return _index;
    }

}