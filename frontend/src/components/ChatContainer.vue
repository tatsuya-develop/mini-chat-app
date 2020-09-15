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
      <div class="chatMain">
        <p>メッセージ1</p>
        <p>メッセージ2</p>
        <p>メッセージ3</p>
        <p>メッセージ4</p> 
      </div>
      <div class="chatBottom">
        <input type="text" class="inputMessage">
        <button class="submit btn-healthy">{{ submit_button }}</button>
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
import Const from '../config/const.js';
import Message from '../config/message.js';
import _ from 'lodash';
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
    },
  },
  data() {
    return {
      frontend_error_message: '',
      chat_group: [],
      input_text: '',
      backend_error_message_detail: '',
      message: '',
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
    backend_error_message: () => Common.GENERATE_LENTICULAR_BRACKET(Message.BACKEND_ERROR.UPDATE),
    delete_confirm_message: () => Message.DELETE_CONFIRM_MESSAGE,
    submit_button: () => Const.SUBMIT,
    edit_link: () => Const.EDIT,
    delete_link: () => Const.DELETE,
    single_text_box_modal_button: () => Const.UPDATE,
    please_select_chat_group_message: () => Message.PLEASE_SELECT_CHAT_GROUP_MESSAGE,
    please_create_chat_group_message: () => Message.PLEASE_CREATE_CHAT_GROUP_MESSAGE,
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
          this.backend_error_message_detail = error.response.data.message;
          console.error(error.response.data);
        });
    },
    deleteChatGroup: function() {
      axios.delete(Const.API_URL + `chat_groups/${this.selected_chat_group.id}`)
        .then((response) => {
          this.removalSelectedChatGroup(response.data);
          this.$modal.hide(this.delete_modal_name);
        })
        .catch((error) => {
          this.showModal(this.error_modal_name);
          this.backend_error_message_detail = error.response.data.message;
          console.error(error.response.data);
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