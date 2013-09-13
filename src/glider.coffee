###
 glider 0.0.3 - AngularJS slider
 https://github.com/evrone/glider
 Copyright (c) 2013 Valentin Vasilyev, Dmitry Karpunin
 Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) license.
###
app = angular.module("glider", [])
# example:
# <slider min="0" max="100" step="1" value="age"></slider>
#
app.directive "slider", ["$document", ($document) ->

  getSubElement = (sliderElement, className) ->
    sliderElement[0].getElementsByClassName(className)[0]

  moveHandle = (elem, posX) ->
    angular.element(getSubElement(elem, "handle")).css("left", "#{posX}%")
    angular.element(getSubElement(elem, "range")).css("width", "#{posX}%")

  template: """
    <span class="g-slider horizontal">
      <span class="slider">
        <span class="range"></span>
        <span class="handle" ng-mousedown="mouseDown($event)"></span>
      </span>
      <span class="side dec">
        <span class="button" ng-click="step(-1)">-</span>
        <span class="bound-value">{{min()}}</span>
      </span>
      <span class="side inc">
        <span class="button" ng-click="step(+1)">+</span>
        <span class="bound-value">{{max()}}</span>
      </span>
    </span>
    """
  replace: true
  restrict: "E"
  scope:
    value: "="
    min: "&"
    max: "&"

  link: (scope, element, attrs) ->
    sliderElement = getSubElement(element, "slider")
    dragging = false
    xPosition = 0
    step = if attrs.step? then parseInt(attrs.step, 10) else 1

    scope.value = scope.min() unless scope.value?

    refreshHandle = ->
      range = scope.max() - scope.min()
      if range is 0
        xPosition = 0
      else
        xPosition = (scope.value - scope.min()) / range * 100
        xPosition = Math.min(Math.max(0, xPosition), 100)
      moveHandle element, xPosition

    scope.$watch "min()", (minValue) ->
      if scope.value < minValue
        scope.value = minValue
      else
        refreshHandle()

    scope.$watch "max()", (maxValue) ->
      if scope.value > maxValue
        scope.value = maxValue
      else
        refreshHandle()

    scope.$watch "value", ->
      return  if dragging
      refreshHandle()

    scope.step = (steps) ->
      newValue = scope.value + steps * step
      if scope.min() <= newValue <= scope.max()
        scope.value = newValue

    scope.mouseDown = ($event) ->
      dragging = true
      startPointX = $event.pageX

      $document.on "mousemove", ($event) ->
        return  unless dragging

        # Calculate value handle position
        moveDelta = $event.pageX - startPointX
        xPosition += moveDelta / sliderElement.offsetWidth * 100
        if xPosition < 0
          xPosition = 0
        else if xPosition > 100
          xPosition = 100
        else
          startPointX = $event.pageX
        scope.value = Math.round((((scope.max() - scope.min()) * (xPosition / 100)) + scope.min()) / step) * step
        scope.$apply()

        moveHandle element, xPosition

      # TODO check binding leaks
      $document.on "mouseup", ->
        dragging = false
        $document.off "mousemove"
]
