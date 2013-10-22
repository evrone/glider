###
  glider 0.1.3 - AngularJS slider
  https://github.com/evrone/glider
  Copyright (c) 2013 Valentin Vasilyev, Dmitry Karpunin
  Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) license.

  examples:

  basic:
  <slider min="0" max="100" step="1" value="age"></slider>

  update only on mouse up:
  <slider defer_update min="0" max="100" step="1" value="age"></slider>

  show value in handle:
  <slider show_value_in_handle min="0" max="100" step="1" value="age"></slider>

  slider with increments (incompatible with step option)
  <slider min="0" max="100" increments="10,50,60,90"></slider>
###
'use strict';
gliderModule = angular.module('glider', [])

gliderModule.directive 'slider', ['$document', ($document) ->

  getSubElement = (sliderElement, className) ->
    sliderElement[0].getElementsByClassName(className)[0]

  moveHandle = (elem, posX) ->
    angular.element(getSubElement(elem, 'handle')).css('left', "#{posX}%")
    angular.element(getSubElement(elem, 'range')).css('width', "#{posX}%")

  template: """
    <span class="g-slider horizontal">
      <span class="slider">
        <span class="range"></span>
        <span class="handle" ng-mousedown="mouseDown($event)">
          <span class="value" ng-show="showValueInHandle">{{value | intersperse}}</span>
        </span>
      </span>
      <span class="side dec">
        <span class="button" ng-click="step(-1)">-</span>
        <span class="bound-value">{{min() | intersperse}}</span>
      </span>
      <span class="side inc">
        <span class="button" ng-click="step(+1)">+</span>
        <span class="bound-value">{{max() | intersperse}}</span>
      </span>
      <span class="increments">
        <span ng-repeat="i in increments" class="i" style="left: {{i.offset}}%">
          {{ i.value | intersperse }}
        </span>
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
    parseIncrements = ->
      trim = (input) -> if input then input.replace(/^\s+|\s+$/g, '') else input
      offset = (min, max, value) ->
        value = parseInt(value) - min
        value / Math.abs(max - min) * 100
      if attrs.increments
        min = scope.min()
        max = scope.max()
        increments = attrs.increments.split(',')
        increments = for i in increments when min < parseInt(i) < max
          value: parseInt(trim(i), 10)
          offset: offset(min, max, i)

    createSnapValues = (increments)->
      if attrs.increments?
        ([scope.min(), scope.max()].concat(i.value for i in increments)).sort((a,b) -> a - b)


    sliderElement = getSubElement(element, 'slider')
    dragging = false
    xPosition = 0
    step = if attrs.step? then parseInt(attrs.step, 10) else 1
    deferUpdate =  attrs.deferUpdate?
    scope.showValueInHandle = attrs.showValueInHandle?

    scope.value = scope.min() unless scope.value?

    scope.increments = parseIncrements(attrs.increments)
    scope.snapValues = createSnapValues(scope.increments)

    refreshHandle = ->
      range = scope.max() - scope.min()
      if range is 0
        xPosition = 0
      else
        xPosition = (scope.value - scope.min()) / range * 100
        xPosition = Math.min(Math.max(0, xPosition), 100)
      moveHandle element, xPosition

    scope.$watch 'min()', (minValue) ->
      if scope.value < minValue
        scope.value = minValue
      else
        refreshHandle()

    scope.$watch 'max()', (maxValue) ->
      if scope.value > maxValue
        scope.value = maxValue
      else
        refreshHandle()

    scope.$watch 'value', (newVal, oldVal)->
      return  if dragging
      if scope.min() <= newVal <= scope.max()
        refreshHandle()
      else
        newVal = oldVal

    scope.step = (steps) ->
      doStep = (steps)->
        newValue = scope.value + steps * step
        if scope.min() <= newValue <= scope.max()
          scope.value = newValue

      doIncrement = (steps) ->
        newVal = if steps > 0
          (sv for sv in scope.snapValues when sv > scope.value)[0]
        else
          (sv for sv in scope.snapValues when sv < scope.value).sort((a,b) -> b - a)[0]
        scope.value = newVal if newVal?

      if attrs.increments?
        doIncrement(steps)
      else
        doStep(steps)


    scope.mouseDown = ($event) ->
      return unless angular.element($event.target).hasClass('handle')
      dragging = true
      startPointX = $event.pageX

      updateValue = ->
        scope.value = Math.round((((scope.max() - scope.min()) * (xPosition / 100)) + scope.min()) / step) * step
        scope.$apply()

      snap = ->
        i = 0
        l = scope.snapValues.length

        while i < l
          diff = Math.abs(scope.snapValues[i] - scope.value)
          min = diff unless min?
          if diff <= min
            closest = scope.snapValues[i]
            min = diff
          i++
        scope.value = closest
        scope.$apply()

      $document.on 'mousemove', ($event) ->
        return  unless dragging
        moveDelta = $event.pageX - startPointX
        xPosition += moveDelta / sliderElement.offsetWidth * 100
        if xPosition < 0
          xPosition = 0
        else if xPosition > 100
          xPosition = 100
        else
          startPointX = $event.pageX
        updateValue() unless deferUpdate
        moveHandle element, xPosition

      $document.on 'mouseup', ->
        dragging = false
        updateValue() if deferUpdate
        snap() if scope.increments
        $document.off 'mousemove'
]
gliderModule.filter 'intersperse', ->
  (input) ->
    return unless input?
    input = input.toString()
    reverse = (input) -> input.split('').reverse().join('')
    reversed = reverse(input)
    reversed_and_sliced = reversed.replace(/(.{3})/g, '$1 ')
    sliced = reverse(reversed_and_sliced)
    sliced.trim()

