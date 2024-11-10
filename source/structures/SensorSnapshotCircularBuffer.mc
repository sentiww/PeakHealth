import Toybox.Lang;

class SensorSnapshotCircularBuffer extends CircularBuffer {

    public function initialize(size as Lang.Number) {
        CircularBuffer.initialize(size);
    }

    public function add(item as SensorSnapshot) as Void {
        CircularBuffer.add(item);
    }

    public function get(index as Lang.Number) as SensorSnapshot {
        return CircularBuffer.get(index);
    }

    public function getLatest() as SensorSnapshot {
        return CircularBuffer.getLatest();
    }

    public function size() as Lang.Number {
        return CircularBuffer.size();
    }

    public function getIndex() as Lang.Number {
        return CircularBuffer.getIndex();
    }

}