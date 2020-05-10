<template>
  <div class="container py-5">
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="basic-addon1">待辦事項</span>
      </div>
      <input
        type="text"
        class="form-control"
        placeholder="準備要做的任務"
        v-model="newTodo"
        @keyup.enter="addTodo"
      />
      <div class="input-group-append">
        <button class="btn btn-primary" type="button" @click="addTodo">新增</button>
      </div>
    </div>
    <div class="card text-center">
      <div class="card-header">
        <ul class="nav nav-tabs card-header-tabs">
          <li class="nav-item">
            <a
              class="nav-link"
              :class="{'active': visibility === 'all' }"
              @click="visibility = 'all'"
              href="#"
            >全部</a>
          </li>
          <li class="nav-item">
            <a
              class="nav-link"
              :class="{'active': visibility === 'active' }"
              @click="visibility = 'active'"
              href="#"
            >進行中</a>
          </li>
          <li class="nav-item">
            <a
              class="nav-link"
              :class="{'active': visibility === 'completed' }"
              @click="visibility = 'completed'"
              href="#"
            >已完成</a>
          </li>
        </ul>
      </div>
      <ul class="list-group list-group-flush text-left">
        <li
          class="list-group-item"
          v-for="todo in filteredTodos"
          @dblclick="editTodo(todo)"
          :key="todo.id"
        >
          <div class="d-flex" v-if="todo !== cacheTodo">
            <div class="form-check">
              <input
                type="checkbox"
                class="form-check-input"
                v-model="todo.completed"
                @click="checkTodo(todo)"
                id="a1"
              />
              <label
                class="form-check-label"
                :class="{'completed': todo.completed}"
                for="a1"
              >{{todo.title}}</label>
            </div>
            <button
              type="button"
              class="close ml-auto"
              aria-label="Close"
              @click="removeTodo(todo)"
            >
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <input
            type="text"
            class="form-control"
            v-model="editTitle"
            v-if="todo === cacheTodo"
            @keyup.enter="doneEdit(todo)"
            @keyup.esc="cancelEdit"
          />
        </li>
      </ul>
      <div class="card-footer d-flex justify-content-between">
        <span>還有 {{ uncompletedTodoCount }} 筆任務未完成</span>
        <a href="#" @click="clearTodo">清除所有任務</a>
      </div>
    </div>
  </div>
</template>

<style>
@import "./css/all.css";

.completed {
  text-decoration: line-through;
}
</style>

<script>
export default {
  data() {
    return {
      newTodo: "",
      todos: [],
      visibility: "all",
      cacheTodo: {},
      editTitle: ""
    };
  },
  mounted() {
    this.todos = JSON.parse(localStorage.getItem("todos")) || [];
  },
  computed: {
    uncompletedTodoCount() {
      return this.todos.filter(todo => !todo.completed).length;
    },
    filteredTodos() {
      switch (this.visibility) {
        case "all":
          return this.todos;
        case "active":
          return this.todos.filter(todo => !todo.completed);
        case "completed":
          return this.todos.filter(todo => todo.completed);
      }
      // default return this.todos
      return this.todos;
    }
  },
  watch: {
    todos() {
      this.saveTodo();
    }
  },
  methods: {
    checkTodo(todo) {
      const newTodo = {
        ...todo,
        completed: !todo.completed
      };
      this.$set(this.todos, this.todos.indexOf(todo), newTodo);
    },
    clearTodo() {
      this.todos = [];
    },
    addTodo() {
      if (!this.newTodo.trim()) return;
      this.todos.push({
        id: Date.now(),
        title: this.newTodo,
        completed: false
      });
      this.newTodo = "";
    },
    removeTodo(removeTodo) {
      this.todos = this.todos.filter(todo => todo.id !== removeTodo.id);
    },
    editTodo(todo) {
      this.cacheTodo = todo;
      this.editTitle = todo.title;
    },
    doneEdit(todo) {
      const newTodo = {
        ...todo,
        title: this.editTitle
      };
      this.$set(this.todos, this.todos.indexOf(todo), newTodo);
      this.cacheTodo = {};
      this.editTitle = "";
    },
    cancelEdit() {
      this.cacheTodo = {};
      this.editTitle = "";
    },
    saveTodo() {
      localStorage.setItem("todos", JSON.stringify(this.todos));
    }
  }
};
</script>