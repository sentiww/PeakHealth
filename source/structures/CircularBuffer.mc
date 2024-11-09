import Toybox.Lang;

class CircularBuffer {

    private var _size as Lang.Number;
    private var _array as Lang.Array;
    private var _index as Lang.Number;

    function initialize(size) {
        _size = size;
        _array = new [size];
        _index = size;
    }

    function add(item) {
        if (_index == _array.size()) {
            _index = 0;
        }

        _array[_index] = item;
        _index += 1;
    }

    function get(index) {
        return _array[index];
    }

    function getLatest() {
        return _array[_index - 1];
    }

    function size() {
        return _size;
    }

    function getIndex() {
        return _index;
    }

}