<template>
    <modal v-bind:name="name" width="400px" height="250px">
      <div class="modal-body">
        <div class="message-area">
          <div class="summary">{{ message }}</div>
          <div ckass="detail">{{ message_detail }}</div>
        </div>
        <div class=""></div>
        <div class="button-area">
          <button class="btn-primary" v-on:click="hide(name)">{{ button_ok }}</button>
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
    'message_detail': String,
    'hide': Function,
  },
  computed: {
    button_ok: () => Const.OK,
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

.message-area, .button-area {
  text-align: center;
  margin: 3rem 0;
}

.summary {
  font-size: 20px;
  margin: 1rem 0
}

.detail {
  margin: 1rem 0;
  font-size: 14px;
}

</style>