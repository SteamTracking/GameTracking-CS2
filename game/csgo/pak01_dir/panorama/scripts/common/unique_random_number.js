"use strict";
var UniqueRandomUtils;
(function (UniqueRandomUtils) {
    class UniqueRandomGenerator {
        numbers;
        currentIndex;
        constructor(min, max) {
            this.numbers = [];
            for (let i = min; i <= max; i++) {
                this.numbers.push(i);
            }
            this.currentIndex = this.numbers.length - 1;
            this.shuffle();
        }
        shuffle() {
            for (let i = this.numbers.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [this.numbers[i], this.numbers[j]] = [this.numbers[j], this.numbers[i]];
            }
        }
        next() {
            if (this.currentIndex < 0) {
                return null;
            }
            return this.numbers[this.currentIndex--];
        }
        reset() {
            this.shuffle();
            this.currentIndex = this.numbers.length - 1;
        }
    }
    UniqueRandomUtils.UniqueRandomGenerator = UniqueRandomGenerator;
})(UniqueRandomUtils || (UniqueRandomUtils = {}));
