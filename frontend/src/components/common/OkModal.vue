<template>
    <modal v-bind:name="name" width="350px" height="200px">
      <div class="modal-body">
        <div class="input-area">
          {{ message }}
        </div>
        <div class="button-area">
          <button v-on:click="hide(name)">{{ button_ok }}</button>
        </div>
      </div>
    </modal>
</template>

<script>
import Const from '../../config/const.js';

export default {
  props: [
    'name',     // String
    'message',  // String
    'hide',     // Method
    'register', // Method
  ],
  data () {
    return {
      button_ok: Const.OK
    };
  },
  methods: {},
}
</script>


<style lang="css" scoped>
.modal-header, .modal-body {
  padding: 5px 25px;
}

.modal-header {
  border-bottom: 1px solid #ddd;
}

.input-area, .button-area {
  text-align: center;
  margin: 3rem 0;
  font-size: 20px;
}

.button-area > button {
  width: 100px;
  font-size: 18px;
}
</style>