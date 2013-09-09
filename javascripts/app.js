angular.module('gliderDemo', ['glider']).controller('gliderController', function($scope){
  $scope.age = 32;
  $scope.weight = 90;

  $scope.dynamic_min = 30;
  $scope.dynamic_max = 70;

  $scope.getDynamicMin = function(){
    $scope.dynamic_min;
  }
  $scope.getDynamicMax = function(){
    $scope.dynamic_min;
  }

  $scope.dynamic_value = $scope.dynamic_min + ($scope.dynamic_max - $scope.dynamic_min)/2;

});