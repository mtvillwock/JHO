// Re: Angular
//https://scotch.io/tutorials/angularjs-best-practices-directory-structure
//https://github.com/johnpapa/angular-styleguide

// Re: Using JWT for authentication
// https://github.com/Foxandxss/rails-angular-jwt-example

// Re: Testing AngularJS apps
// https://quickleft.com/blog/angularjs-unit-testing-for-real-though/

(function() {
    // inject dependency modules
    var app = angular.module('todoApp', ['dndLists']);
    // for compatibility with Rails CSRF protection
    app.config([
        '$httpProvider',
        function($httpProvider) {
            $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
        }
    ]);

    // start boardController
    app.controller('boardController', function() {
        var board = this;
        // should we do board.models.lists or boards.lists.cards etc.?
        board.lists = [{
            name: "Interested In"
        }, {
            name: "Applied"
        }, {
            name: "Interviewed"
        }]
    }); // End of boardController

    // Extract this to separate file later
    // start TodoListController
    app.controller('TodoListController', function() {
        var todoList = this;
        todoList.todos = [{
            text: 'learn angular',
            done: true
        }, {
            text: 'build an angular app',
            done: false
        }];

        todoList.addTodo = function() {
            todoList.todos.push({
                text: todoList.todoText,
                done: false
            });
            todoList.todoText = '';
        };

        todoList.remaining = function() {
            var count = 0;
            angular.forEach(todoList.todos, function(todo) {
                count += todo.done ? 0 : 1;
            });
            return count;
        };

        todoList.archive = function() {
            var oldTodos = todoList.todos;
            todoList.todos = [];
            angular.forEach(oldTodos, function(todo) {
                if (!todo.done) todoList.todos.push(todo);
            });
        };
    });
    // end todoListController
})();