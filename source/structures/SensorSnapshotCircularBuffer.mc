import Toybox.Lang;

class SensorSnapshotCircularBuffer extends CircularBuffer {

    public function initialize(size as Number) {
        CircularBuffer.initialize(size);
    }

    public function add(item as SensorSnapshot) as Void {
        CircularBuffer.add(item);
    }

    public function get(index as Number) as SensorSnapshot {
        return CircularBuffer.get(index);
    }

    public function getLatest() as SensorSnapshot {
        return CircularBuffer.getLatest();
    }

    public function size() as Number {
        return CircularBuffer.size();
    }

    public function getIndex() as Number {
        return CircularBuffer.getIndex();
    }

}