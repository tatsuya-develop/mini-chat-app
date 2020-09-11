<template>
  <div class="chatContainer" v-if="_selected_chat_group">
    <div class="chatTop">
      <div class="groupAlia">
        <div class="groupTitle">
          {{ _selected_chat_group.name }}
        </div>
        <div class="groupEdit link" v-on:click="showModal(edit_modal_name)">
          {{ edit_link }}
        </div>
      </div>
      <div class="groupDelete link">
        {{ delete_link }}
      </div>
    </div>
    <div class="chatMain">
      <p>メッセージ1</p>
      <p>メッセージ2</p>
      <p>メッセージ3</p>
      <p>メッセージ4</p> 
    </div>
    <div class="chatBottom">
      <input type="text" class="inputMessage">
      <button>{{ single_text_box_modal_button }}</button>
    </div>
    <single-text-box-modal
      :name="edit_modal_name" 
      :title="edit_modal_title"
      :input_text="input_text"
      :error_message="frontend_error_message"
      :hide="hideModal" 
      :button_submit="single_text_box_modal_button"
      :parentSubmit="edit"
      :resetErrorMessage="resetErrorMessage"
      @update:input_text="input_text = $event"
    ></single-text-box-modal>
    <ok-modal 
      :name="error_modal_name" 
      :hide="hideModal" 
      :message="backend_error_message"
    ></ok-modal>
  </div>
</template>

<script>
import axios from 'axios';
import Const from '../config/const.js';
import Message from '../config/message.js';
import _ from 'lodash';
import SingleTextBoxModal from './common/SingleTextBoxModal.vue';
import OkModal from './common/OkModal.vue';

export default {
  components: {
    SingleTextBoxModal,
    OkModal,
  },
  data() {
    return {
      edit_modal_name: Const.EDIT_CHAT_GROUP_MODAL_NAME,
      edit_modal_title: Const.EDIT_CHAT_GROUP_MODAL_TITLE,
      error_modal_name: Const.ERROR_MODAL_NAME,
      backend_error_message: Message.BACKEND_ERROR.UPDATE,
      frontend_error_message: '',
      chat_group: [],
      input_text: '',
      submit_button: Const.SUBMIT,
      edit_link: Const.EDIT,
      delete_link: Const.DELETE,
      single_text_box_modal_button: Const.UPDATE,
    };
  },
  props: {
    'selected_chat_group': Object,
  },
  watch: {
    selected_chat_group: function(current, prev) {
      this.input_text = current.name;
    },
  },
  computed: {
    _selected_chat_group: {
      get: function() {
        return this.selected_chat_group;
      },
      set: function(value) {
        this.$emit('update:selected_chat_group', value);
      }
    },
  },
  methods: {
    // チャットグループの更新
    updateChatGroup: function(name) {
      // 未入力であるかをチェック
      if (!this.input_text) {
        this.frontend_error_message = Message.FRONTEND_ERROR.NO_INPUT;
        return false;
      }
      // パラメータ設定
      const params = _.cloneDeep(this.selected_chat_group);
      params.name = name;
      // チャットグループの更新
      axios.put(Const.API_URL + `chat_groups/${params.id}`, params)
        .then((response) => {
          // 入力値の初期化と、入力モーダルを閉じる
          this._selected_chat_group = response.data;
          this.$modal.hide(this.edit_modal_name);
        })
        .catch((error) => {
          this.showModal(this.error_modal_name);
          console.error(error);
        });
    },
    // モーダルオープン時の処理
    showModal: function(target_modal_name) {
      this.$modal.show(target_modal_name);
    },
    // モーダルクローズ時の処理
    hideModal: function(target_modal_name) {
      if (target_modal_name === this.edit_modal_name) {
        this.input_text = this._selected_chat_group.name;
      }
      this.$modal.hide(target_modal_name);
    },
    // モーダルアクション時の処理
    edit: function() {
      this.updateChatGroup(this.input_text);
    },
    // front_error_message のリセット
    resetErrorMessage: function() {
      this.frontend_error_message = '';
    }
  }
}
</script>

<style lang="css" scoped>
.chatContainer {
  width: 80%;
  padding: 1em;
}

.link {
  color: gray;
  font-size: 11px;
  cursor: pointer;
}

.chatTop {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  border-bottom-color: black;
  border-bottom-width: thin;
  border-bottom-style: solid;
  padding-bottom: 1rem;
}

.groupAlia {
  display: flex;
  align-items: flex-end;
}

.groupTitle {
  font-size: 18px;
}

.groupEdit {
  margin-left: 1rem;
}

.chatMain {
  height: 85vh;
}

.chatBottom {
  display: flex;
  justify-content: space-between;
}

.inputMessage {
  font-size: 16px;
  width: 95%;
  height: 30px;
}

</style>