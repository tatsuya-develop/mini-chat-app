<template>
  <div class="sidebar">
    <button class="addButton">+</button>
    <div class="chatGroupList">
      <div class="chatGroup">
        <div class="groupName">
          チャットグループ名1
        </div>
        <div class="unreadBadge">2</div>
      </div>
      <div class="chatGroup">
        <div class="groupName">
          チャットグループ名2
        </div>
      </div>
      <div class="chatGroup">
        <div class="groupName">
          チャットグループ名3
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  
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

.unreadBadge {
  background: red;
  color: white;
  border-radius: 50px;
  width: 40px;
  height: 20px;
  font-size: 14px;
  text-align: center;
  margin-right: 5px;
}

.unread {
  padding-left: 1rem;
}

</style>