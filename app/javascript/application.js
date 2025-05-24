// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// Import any libraries pinned in importmap
import Winwheel from "winwheel";

// Example initialization (you can move this to another file if preferred)

document.addEventListener("DOMContentLoaded", () => {
  const items = ["wear a tutu", "buy the beers", "sing a song"]; // or pass from Rails via JSON

  function getRandomColor() {
    return '#' + Math.floor(Math.random() * 16777215).toString(16).padStart(6, '0');
  }

  function createWheel(items) {
    const segments = items.map(item => ({ fillStyle: getRandomColor(), text: item }));
    return new Winwheel({
      canvasId: 'dickWheelCanvas',
      numSegments: items.length,
      segments: segments,
      animation: {
        type: 'spinToStop',
        duration: 5,
        spins: 8,
        callbackFinished: alertPrize
      }
    });
  }

  function alertPrize(indicatedSegment) {
    alert(`Result: ${indicatedSegment.text}`);
  }

  // Only run if canvas element exists
  const canvas = document.getElementById('dickWheelCanvas');
  if (canvas) {
    const theWheel = createWheel(items);

    const spinBtn = document.getElementById("spinWheelBtn");
    if (spinBtn) {
      spinBtn.addEventListener("click", () => {
        theWheel.stopAnimation(false);
        theWheel.rotationAngle = 0;
        theWheel.startAnimation();
      });
    }
  }
});
