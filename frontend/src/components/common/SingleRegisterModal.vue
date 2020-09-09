<template>
    <modal v-bind:name="name" :clickToClose=false>
      <div class="modal-header">
        <h2>{{ title }}</h2>
      </div>
      <div class="modal-body">
        <div class="input-area">
          <input type="text" class="" v-model="_input_text">
        </div>
        <div class="error-area">
          <span>{{ error_message }}</span>
        </div>
        <div class="button-area">
          <button v-on:click="register()">{{ button_register }}</button>
          <button v-on:click="cancel(name)">{{ button_cancel }}</button>
        </div>
      </div>
    </modal>
</template>

<script>
import Const from '../../config/const.js';

export default {
  props: [
    'name',           // String
    'title',          // String
    'input_text',     // String
    'error_message',  // String
    'hide',           // Method
    'parentRegister', // Method
  ],
  data () {
    return {
      button_register: Const.REGISTER,
      button_cancel: Const.CANCEL,
    };
  },
  computed: {
    _input_text: {
      get: function() {
        return this.input_text;
      },
      set: function(value) {
        this.$emit('update:input_text', value);
      }
    },
  },
  methods: {
    register: function () {
      this.parentRegister();
    },
    cancel: function () {
      this._input_text = '';
      this.hide(this.name);
    },
  }
}
</script>


<style lang="css" scoped>
.modal-header, .modal-body {
  padding: 5px 25px;
}

.modal-header {
  border-bottom: 1px solid #ddd;
  text-align: center;
}

.input-area {
  margin: 2rem 1rem;
}

input {
  width: 100%;
  height: 30px;
  font-size: 18px;
}

.button-area {
  text-align: right;
  margin-top: 1rem;
}

.button-area > button {
  width: 120px;
  margin: 0.5rem;
  font-size: 18px;
}
</style>