// Creating our main Angular module
var VideoTaggingApp = angular.module("VideoTaggingApp", ['ngRoute', 'ngSanitize', 'videoTaggingAppControllers'])


.config(function ($routeProvider) {
    
    $routeProvider
    .when('/', {
        controller: 'AppController',
        templateUrl: 'partials/welcome.html',
        
    })
    .when('/jobs/:id/tag', {
        controller: 'TagJobController',
        templateUrl: 'partials/tagJob.html',
        auth: true
    })
    .when('/jobs/:id', {
        controller: 'UpsertJobController',
        templateUrl: 'partials/upsertjob.html',
        auth: true
    })
    .when('/jobs', {
        controller: 'JobsController',
        templateUrl: 'partials/jobs.html',
        activetab: 'jobs',
        auth: true
    })
    .when('/videos', {
        controller: 'VideosController',
        templateUrl: 'partials/videos.html',
        activetab: 'videos',
        auth: true
    })
    .when('/videos/:id', {
        controller: 'UpsertVideoController',
        templateUrl: 'partials/upsertVideo.html',
        auth: true
    })
    .when('/users', {
        controller: 'UsersController',
        templateUrl: 'partials/users.html',
        activetab: 'users',
        auth: true
    })
    .when('/users/:id', {
        controller: 'UpsertUserController',
        templateUrl: 'partials/upsertUser.html',
        activetab: 'users',
        auth: true
    })
    .when('/about', {
        templateUrl: 'partials/about.html',
        activetab: ''
    })
    .when('/contact', {
        templateUrl: 'partials/contact.html',
        activetab: ''
    })
    .when('/terms', {
        templateUrl: 'partials/terms.html',
        activetab: ''
    })
    .otherwise({
        redirectTo: '/'
    });
})

.run(function ($rootScope, $route, $location) {
    
    $rootScope.$on("$routeChangeSuccess", function (current) {
        var authRequired = $route.current && 
                    $route.current.$$route && 
                    $route.current.$$route.auth;
        if (authRequired && !$rootScope.user) {
            console.info("Authentication error",
                           "You need to be signed in to view that page.<br/><br/>" +
                           "Please sign in and we'll have you viewing that page in a jiffy");
           // var currentUrl = $location.url();
            console.error('not logged in');

            $location.url("/welcome");
        }
    });
    
    /*
      
    $rootScope.$on('$stateChangeStart', function (event, toState, toParams) {
        var requireLogin = toState.data.requireLogin;
        
        if (requireLogin && typeof $rootScope.user === 'undefined') {
            event.preventDefault();
      // get me a login modal!
        }
    });
    */
});

$(document).ready(function () {
    $(".navbar-nav li a[href!='']").click(function (event) {
        $(".navbar-collapse").collapse('hide');
    });

   
});
