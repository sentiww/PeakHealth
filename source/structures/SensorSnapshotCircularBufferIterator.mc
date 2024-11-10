import Toybox.Lang;

class SensorSnapshotCircularBufferIterator extends CircularBufferIterator {

    public function initialize(buffer as SensorSnapshotCircularBuffer) {
        CircularBufferIterator.initialize(buffer);
    }

    public function getNext() as SensorSnapshot {
        return CircularBufferIterator.getNext();
    }

    public function hasMore() as Lang.Boolean {
        return CircularBufferIterator.hasMore();
    }

    public function reset() as Void {
        CircularBufferIterator.reset();
    }

}