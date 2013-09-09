###
 glider 0.0.1 - Angularjs slider
 https://github.com/Valve/glider
 Copyright (c) 2013 Valentin Vasilyev, Dmitry Karpunin
 Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) license.
###
app = angular.module("glider", [])
# example:
# <slider min="0" max="100" step="1" value="scope.age"></slider>
#
app.directive "slider", ["$document", ($document) ->

  moveHandle = (elem, posX) ->
    angular.element(elem[0].getElementsByClassName('handle')[0]).css("left", "#{posX}%")
    angular.element(elem[0].getElementsByClassName('range')[0]).css("width", "#{posX}%")

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
    min: '&'
    max: '&'

  link: (scope, element, attrs) ->
    dragging = false
    startPointX = 0
    xPosition = 0
    step = if attrs.step? then parseInt(attrs.step, 10) else 1

    scope.value = scope.min() unless scope.value?

    scope.$watch "value", ->
      return  if dragging
      xPosition = (scope.value - scope.min()) / (scope.max() - scope.min()) * 100
      if xPosition < 0
        xPosition = 0
      else xPosition = 100  if xPosition > 100
      moveHandle(element, xPosition)


    scope.step = (step_value) ->
      scope.value += step_value * step

    scope.mouseDown = ($event) ->
      dragging = true
      startPointX = $event.pageX

      $document.on "mousemove", ($event) ->
        return  unless dragging

        #Calculate handle position
        moveDelta = $event.pageX - startPointX
        xPosition = xPosition + ((moveDelta / element[0].offsetWidth) * 100)
        if xPosition < 0
          xPosition = 0
        else if xPosition > 100
          xPosition = 100
        else
          startPointX = $event.pageX
        scope.value = Math.round((((scope.max() - scope.min()) * (xPosition / 100)) + scope.min()) / step) * step
        scope.$apply()

        moveHandle(element, xPosition)

      $document.on 'mouseup', ->
        dragging = false
        $document.off("mousemove")
]
