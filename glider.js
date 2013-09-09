/*
 glider 0.0.2 - Angularjs slider
 https://github.com/Valve/glider
 Copyright (c) 2013 Valentin Vasilyev, Dmitry Karpunin
 Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) license.
*/


(function() {
  var app,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  app = angular.module("glider", []);

  app.directive("slider", [
    "$document", function($document) {
      var moveHandle;
      moveHandle = function(elem, posX) {
        angular.element(elem[0].getElementsByClassName('handle')[0]).css("left", "" + posX + "%");
        return angular.element(elem[0].getElementsByClassName('range')[0]).css("width", "" + posX + "%");
      };
      return {
        template: "<span class=\"g-slider horizontal\">\n  <span class=\"slider\">\n    <span class=\"range\"></span>\n    <span class=\"handle\" ng-mousedown=\"mouseDown($event)\"></span>\n  </span>\n  <span class=\"side dec\">\n    <span class=\"button\" ng-click=\"step(-1)\">-</span>\n    <span class=\"bound-value\">{{min()}}</span>\n  </span>\n  <span class=\"side inc\">\n    <span class=\"button\" ng-click=\"step(+1)\">+</span>\n    <span class=\"bound-value\">{{max()}}</span>\n  </span>\n</span>",
        replace: true,
        restrict: "E",
        scope: {
          value: "=",
          min: '&',
          max: '&'
        },
        link: function(scope, element, attrs) {
          var dragging, startPointX, step, xPosition;
          dragging = false;
          startPointX = 0;
          xPosition = 0;
          step = attrs.step != null ? parseInt(attrs.step, 10) : 1;
          if (scope.value == null) {
            scope.value = scope.min();
          }
          scope.$watch("value", function() {
            if (dragging) {
              return;
            }
            xPosition = (scope.value - scope.min()) / (scope.max() - scope.min()) * 100;
            if (xPosition < 0) {
              xPosition = 0;
            } else {
              if (xPosition > 100) {
                xPosition = 100;
              }
            }
            return moveHandle(element, xPosition);
          });
          scope.step = function(step_value) {
            var inc, _i, _ref, _ref1, _ref2, _results;
            inc = step_value * step;
            if (_ref = scope.value + inc, __indexOf.call((function() {
              _results = [];
              for (var _i = _ref1 = scope.min(), _ref2 = scope.max(); _ref1 <= _ref2 ? _i <= _ref2 : _i >= _ref2; _ref1 <= _ref2 ? _i++ : _i--){ _results.push(_i); }
              return _results;
            }).apply(this), _ref) >= 0) {
              return scope.value += inc;
            }
          };
          return scope.mouseDown = function($event) {
            dragging = true;
            startPointX = $event.pageX;
            $document.on("mousemove", function($event) {
              var moveDelta;
              if (!dragging) {
                return;
              }
              moveDelta = $event.pageX - startPointX;
              xPosition = xPosition + ((moveDelta / element[0].offsetWidth) * 100);
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
            return $document.on('mouseup', function() {
              dragging = false;
              return $document.off("mousemove");
            });
          };
        }
      };
    }
  ]);

}).call(this);
