<template>
    <modal v-bind:name="name" width="500px" height="200px">
      <div class="modal-body">
        <div class="input-area">
          {{ message }}
        </div>
        <div class="button-area">
          <button class="btn-primary" v-on:click="submit()">{{ button_yes }}</button>
          <button v-on:click="hide(name)">{{ button_no }}</button>
        </div>
      </div>
    </modal>
</template>

<script>
import Const from '../../config/const.js';

export default {
  props: {
    'name': String,
    'message': String,
    'hide': Function,
    'submit': Function,
  },
  computed: {
    button_yes: () => Const.YES,
    button_no: () => Const.NO,
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

</style>