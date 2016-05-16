



//3
var app = angular.module('MyApp', []);

app.controller('ClockController', function($scope){
	$scope.clock = {
		now: new Date()
	};
	var updateClock = function() {
		$scope.clock.now = new Date()
	};

	setInterval(function() {
		$scope.$apply(updateClock);
	}, 1000);

updateClock();
})

app.controller('FirstController', function($scope) {
	$scope.counter = 0;
	$scope.add = function(amount) { $scope.counter += amount; };
	$scope.subtract = function(amount) { $scope.counter -= amount;  };
});

app.controller('MyController', function($scope) {
       $scope.person = {
         name: 'Ari Lerner'
       };
});

app.controller('ParentController', function($scope) { 
	$scope.person = {greeted: false};
});

app.controller('ChildController', function($scope) {
	$scope.sayHello = function() {
		$scope.person.name = 'Ari Lerner';
	};
});