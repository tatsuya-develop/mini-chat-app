<template>
  <div class="chatContainer">
    <!-- チャットグループ一覧が空、またはチャットグループが未選択の状態の場合 -->
    <div class="guide-message" v-if="!chat_groups || chat_groups.length === 0">
      <h2>{{ please_create_chat_group_message }}</h2>
    </div>
    <!-- チャットグループ一覧に1件以上存在するが、チャットグループが未選択の状態 -->
    <div class="guide-message" v-else-if="!_selected_chat_group">
      <h2>{{ please_select_chat_group_message }}</h2>
    </div>
    <!-- チャットグループ一覧に1件以上存在し、チャットグループも選択している状態 -->
    <div v-else>
      <div class="chatTop">
        <div class="groupAlia">
          <div class="groupTitle">
            {{ _selected_chat_group.name }}
          </div>
          <div class="groupEdit link" v-on:click="showModal(edit_modal_name)">
            {{ edit_link }}
          </div>
        </div>
        <div class="groupDelete link" v-on:click="showModal(delete_modal_name)">
          {{ delete_link }}
        </div>
      </div>
      <div class="chatMain" id="messageArea">
        <p v-for="message in messages" :key="message.id">
          {{ message.body }}
        </p>
      </div>
      <div class="chatBottom">
        <input 
          type="text" 
          class="inputMessage" 
          v-model="input_message" 
          placeholder="入力してください..."
          v-bind:maxlength="max_length_string"
          @keypress.prevent.enter.exact="enableEnterMessageSubmit()" 
          @keyup.prevent.enter.exact="enterMessageSubmit()"
        >
        <button class="submit btn-healthy" v-if="message_channel" v-on:click="sendMessage()" v-bind:disabled="is_disabled">{{ submit_button }}</button>
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
        :message_detail="backend_error_message_detail"
      ></ok-modal>
      <yes-no-modal
        :name="delete_modal_name"
        :hide="hideModal"
        :message="delete_confirm_message"
        :submit="deleteChatGroup"
      ></yes-no-modal>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import _ from 'lodash';
import Const from '../config/const.js';
import Message from '../config/message.js';
import SingleTextBoxModal from './common/SingleTextBoxModal.vue';
import OkModal from './common/OkModal.vue';
import YesNoModal from './common/YesNoModal.vue';
import Common from '../config/common.js';

export default {
  components: {
    SingleTextBoxModal,
    OkModal,
    YesNoModal,
  },
  props: {
    'selected_chat_group': Object,
    'chat_groups': Array,
    'removalSelectedChatGroup': Function,
  },
  watch: {
    selected_chat_group: function(current) {
      this.input_text = current ? current.name : '';
      if (current) {
        this.getMessage();
      }
    },
    messages: function() {
      // DOM生成が完了したあとに実行
      this.$nextTick(() => {
        // スクロールが発生しても、常に最新のメッセージが見れるようにする
        const target = document.getElementById('messageArea');
        if (target) {
          target.scrollTop = target.scrollHeight;
        }
      });
    },
    input_message: function(current) {
      // メッセージが、空白または最大文字数を超えている場合は、ボタンを非活性にする
      const maxLength = 255;
      this.is_disabled = !current || current.length > this.get_max_length;
    }
  },
  data() {
    return {
      frontend_error_message: '',
      chat_group: [],
      input_text: '',
      input_message: '',
      backend_error_message: '',
      backend_error_message_detail: '',
      messages: [],
      message_channel: null,
      is_disabled: true,
      is_can_send_message: false,
    };
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
    edit_modal_name: () => Const.EDIT_CHAT_GROUP_MODAL_NAME,
    edit_modal_title: () => Const.EDIT_CHAT_GROUP_MODAL_TITLE,
    delete_modal_name: () => Const.DELETE_CHAT_GROUP_MODAL_NAME,
    error_modal_name: () => Const.CHAT_CONTAINER_ERROR_MODAL_NAME,
    delete_confirm_message: () => Message.DELETE_CONFIRM_MESSAGE,
    submit_button: () => Const.SUBMIT,
    edit_link: () => Const.EDIT,
    delete_link: () => Const.DELETE,
    single_text_box_modal_button: () => Const.UPDATE,
    please_select_chat_group_message: () => Message.PLEASE_SELECT_CHAT_GROUP_MESSAGE,
    please_create_chat_group_message: () => Message.PLEASE_CREATE_CHAT_GROUP_MESSAGE,
    max_length_string: () => Const.MAX_LENGTH_STRING,
  },
  created: function() {
    this.message_channel = this.$cable.subscriptions.create(
      { channel: 'MessageChannel' }, 
      {
        received: (data) => {
          this.messages.push(data.message);
          this.input_message = '';
        }
      }
    )
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
          this.backend_error_message = Common.GENERATE_LENTICULAR_BRACKET(Message.BACKEND_ERROR.UPDATE);
          this.backend_error_message_detail = error.response.data.message;
          console.error(error.response.data);
        });
    },
    // チャットグループの削除
    deleteChatGroup: function() {
      axios.delete(Const.API_URL + `chat_groups/${this.selected_chat_group.id}`)
        .then((response) => {
          this.removalSelectedChatGroup(response.data);
          this.$modal.hide(this.delete_modal_name);
        })
        .catch((error) => {
          this.hideModal(this.delete_modal_name);
          this.showModal(this.error_modal_name);
          this.backend_error_message = Common.GENERATE_LENTICULAR_BRACKET(Message.BACKEND_ERROR.DELETE);
          this.backend_error_message_detail = error.response.data.message;
          console.error(error.response.data);
        });
    },
    // メッセージ受信機能
    getMessage: function() {
      axios.get(Const.API_URL + `messages/${this.selected_chat_group.id}`)
        .then((response) => {
          this.messages = response.data;
        })
        .catch((error) => {
          console.log(error.response.data);
        });
    },
    // メッセージ送信機能
    sendMessage: function() {
      this.message_channel.perform('send_message', {
        message: this.input_message,
        chat_group_id: this.selected_chat_group.id
      });
    },
    // Enterでメッセージが送信できる状態にする
    enterMessageSubmit: function() {
      this.is_can_send_message = true;
    },
    // Enterでメッセージが送信できるかを判定
    enableEnterMessageSubmit: function() {
      if (!this.is_can_send_message) return;
      this.sendMessage();
      this.is_can_send_message = false;
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
  position: relative;
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

.chatMain {
  position: absolute;
  overflow: auto;
  height: 82%;
  width: 95%;
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

.chatBottom {
  display: flex;
  justify-content: space-between;
  position: absolute;
  bottom: 0;
  width: 95%;
  margin: 1rem 0;
}

.inputMessage {
  font-size: 16px;
  width: 95%;
  height: 30px;
}

.submit {
  width: 100px;
  margin-left: 1rem;
}

.guide-message {
  text-align: center;
}

</style>