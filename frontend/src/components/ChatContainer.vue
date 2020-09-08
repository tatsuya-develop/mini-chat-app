<template>
  <div class="chatContainer" v-if="selected_chat_group">
    <div class="chatTop">
      <div class="groupAlia">
        <div class="groupTitle">
          {{ selected_chat_group.name }}
        </div>
        <div class="groupEdit link">
          編集
        </div>
      </div>
      <div class="groupDelete link">
        チャットグループを削除する
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
      <button>送信</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      chat_group: [],
    };
  },
  props: [
    'selected_chat_group',
  ],
}
</script>

<style lang="css">
.chatContainer {
  width: 80%;
  padding: 1em;
}

.link {
  color: gray;
  font-size: 11px;
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