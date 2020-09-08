<template>
  <div class="sidebar">
    <button class="addButton" v-on:click="createChatGroup()">+</button>
    <div class="chatGroupList">
      <div class="chatGroup" v-for="(chat_group, index) in _chat_groups" :key='index'>
        <div class="groupName">
          <span v-on:click="onSelectChatGroup(chat_group.id)" v-bind:value="selected_id">
            {{ chat_group.name }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Const from '../config/const.js';
import Message from '../config/message.js';

export default {
  props: [
    'chat_groups',
    'selected_id',
  ],
  computed: {
    _chat_groups: {
      get: function() {
        return this.chat_groups;
      },
      set: function(value) {
        this.$emit('update:chat_groups', value);
      }
    },
    _selected_id: {
      get: function() {
        return this.selected_id;
      },
      set: function(value) {
        this.$emit('update:selected_id', value);
      }
    }
  },
  methods: {
    // 選択されたチャットグループのIDに更新
    onSelectChatGroup: function (id) {
      this._selected_id = id;
    },
    // チャットグループの作成
    createChatGroup: function () {
      const params = {
        chat_group: {
          name: Const.NEW_CHAT_GROUP,
        }
      };
      axios.post(Const.API_URL + 'chat_groups', params)
        .then((response) => {
          this._chat_groups.push(response.data);
          this.onSelectChatGroup(response.data.id);
        })
        .catch((error) => {
          alert(Message.ERROR.CREATE);
          console.error(error);
        });
    }
  }
}
</script>

<style lang="css">
.sidebar {
  width: 19%;
  padding: 1em;
  color: white;
}

.addButton {
  width: 25px;
  height: 25px;
  border-radius: 50%;
  background: gray;
  color: white;
  border-color: white;
  border-style: solid;
  border-width: thin;
}

.chatGroupList {
  padding: 10px 0;
}

.chatGroup {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
}

.groupName {
  width: 80%;
}

.groupName > span {
  cursor: pointer;
}

</style>