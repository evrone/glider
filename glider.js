/*
 glider 0.0.3 - AngularJS slider
 https://github.com/evrone/glider
 Copyright (c) 2013 Valentin Vasilyev, Dmitry Karpunin
 Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) license.
*/


(function() {
  var app;

  app = angular.module("glider", []);

  app.directive("slider", [
    "$document", function($document) {
      var getSubElement, moveHandle;
      getSubElement = function(sliderElement, className) {
        return sliderElement[0].getElementsByClassName(className)[0];
      };
      moveHandle = function(elem, posX) {
        angular.element(getSubElement(elem, "handle")).css("left", "" + posX + "%");
        return angular.element(getSubElement(elem, "range")).css("width", "" + posX + "%");
      };
      return {
        template: "<span class=\"g-slider horizontal\">\n  <span class=\"slider\">\n    <span class=\"range\"></span>\n    <span class=\"handle\" ng-mousedown=\"mouseDown($event)\"></span>\n  </span>\n  <span class=\"side dec\">\n    <span class=\"button\" ng-click=\"step(-1)\">-</span>\n    <span class=\"bound-value\">{{min()}}</span>\n  </span>\n  <span class=\"side inc\">\n    <span class=\"button\" ng-click=\"step(+1)\">+</span>\n    <span class=\"bound-value\">{{max()}}</span>\n  </span>\n</span>",
        replace: true,
        restrict: "E",
        scope: {
          value: "=",
          min: "&",
          max: "&"
        },
        link: function(scope, element, attrs) {
          var dragging, refreshHandle, sliderElement, step, xPosition;
          sliderElement = getSubElement(element, "slider");
          dragging = false;
          xPosition = 0;
          step = attrs.step != null ? parseInt(attrs.step, 10) : 1;
          if (scope.value == null) {
            scope.value = scope.min();
          }
          refreshHandle = function() {
            var range;
            range = scope.max() - scope.min();
            if (range === 0) {
              xPosition = 0;
            } else {
              xPosition = (scope.value - scope.min()) / range * 100;
              xPosition = Math.min(Math.max(0, xPosition), 100);
            }
            return moveHandle(element, xPosition);
          };
          scope.$watch("min()", function(minValue) {
            if (scope.value < minValue) {
              return scope.value = minValue;
            } else {
              return refreshHandle();
            }
          });
          scope.$watch("max()", function(maxValue) {
            if (scope.value > maxValue) {
              return scope.value = maxValue;
            } else {
              return refreshHandle();
            }
          });
          scope.$watch("value", function() {
            if (dragging) {
              return;
            }
            return refreshHandle();
          });
          scope.step = function(steps) {
            var newValue;
            newValue = scope.value + steps * step;
            if ((scope.min() <= newValue && newValue <= scope.max())) {
              return scope.value = newValue;
            }
          };
          return scope.mouseDown = function($event) {
            var startPointX;
            dragging = true;
            startPointX = $event.pageX;
            $document.on("mousemove", function($event) {
              var moveDelta;
              if (!dragging) {
                return;
              }
              moveDelta = $event.pageX - startPointX;
              xPosition += moveDelta / sliderElement.offsetWidth * 100;
              if (xPosition < 0) {
                xPosition = 0;
              } else if (xPosition > 100) {
                xPosition = 100;
              } else {
                startPointX = $event.pageX;
              }
              scope.value = Math.round((((scope.max() - scope.min()) * (xPosition / 100)) + scope.min()) / step) * step;
              scope.$apply();
              return moveHandle(element, xPosition);
            });
            return $document.on("mouseup", function() {
              dragging = false;
              return $document.off("mousemove");
            });
          };
        }
      };
    }
  ]);

}).call(this);
