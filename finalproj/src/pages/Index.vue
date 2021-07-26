<template>
  <q-page class="bg-grey-3 column">

    <div class="row q-pa-sm bg-primary">
      <q-input 
        filled 
        @keyup.enter="addUser" 
        v-model="username" 
        Placeholder="Name" 
        dense 
        bg-color="white" 
        class="col" 
        square
      >
        <template v-slot:append>
          <q-btn round dense flat @click="addUser" icon="add" />
        </template>
      </q-input> 
    </div>
    <div class="row q-pa-sm bg-primary q-col-gutter-sm ">
    <div class="col-6 ">
      <q-input filled @keyup.enter="addUser" v-model="reason" Placeholder="Reason for visit" dense bg-color="white" square/>
    </div>
    <div class="col-6 ">
      <q-input filled @keyup.enter="addUser" v-model="phone" Placeholder="Phone # for text notification" mask="(###) ###-####" dense bg-color="white" square/>
    </div>
    </div>

    <div class="q-pa-md q-gutter-md">
      <q-list bordered separator class="bg-white rounded-borders">
        <q-item-label header>Current Waiting Queue</q-item-label>
          <q-item v-for="user in ActiveUsernames" :key="user.id" clickable v-ripple>
        
          <q-item-section avatar>
            <q-avatar>
              <img src="~assets/generic_avatar.png">
            </q-avatar>
          </q-item-section>
  
          <q-item-section>
            <q-item-label lines="1">{{ user.name }}</q-item-label>
            <q-item-label caption lines="2">{{ user.reason }}</q-item-label>
          </q-item-section>

          <q-item-section side top>
            <DateDiff :date="new Date(user.timestamp)" />
          </q-item-section>

          <q-item-section side top>
            <q-btn round glossy size="sm" @click="cancel(user)" color="red" icon="highlight_off"/>
          </q-item-section>

        </q-item>
      </q-list>
    </div>
  </q-page>
</template>

<script>
  import DateDiff from 'components/DateDiff.vue'
  import { date } from 'quasar'
  import db from 'boot/firebase'
  export default {
    components: {
      DateDiff
    },
    data() {
      return {
        username: '',
        reason: '',
        phone: '',
        usernames: [],
      }
    },
    methods: {
      async initialize() {
        await db
          .collection('waiting')
          .orderBy("timestamp", "asc")
          .onSnapshot(snapshot => {
            snapshot.docChanges().forEach(change => {
              if (change.type === 'added') {
                //ADD
                const source = change.doc.metadata.hasPendingWrites ? 'Local' : 'Server';
                if (source === 'Server') {
                  let user = change.doc.data();
                  user.id = change.doc.id;
                  this.usernames.push(user);
                }
              }

              if (change.type === 'modified') {
                //UPDATE
                const index = this.usernames.findIndex(item => item.id == change.doc.id);
                let user = change.doc.data();
                user.id = change.doc.id;
                this.usernames.splice(index, 1, user);
              }

              if (change.type === 'removed') {
                //REMOVE
                const index = this.usernames.findIndex(item => item.id == change.doc.id);
                if (index >= 0) {
                  this.usernames.splice(index, 1)
                }
              }
            });
          });
      },
      async addUser() {
        let newuser = {
          name: this.username,
          active: true,
          reason: this.reason,
          phone: this.phone,
          timestamp: Date.now()
        };
        this.usernames.push(newuser);
        await db
          .collection('waiting')
          .add(newuser)
          .then(this.username = '')
          .then(this.reason = '')
          .then(this.phone = '')
          .catch((error) => {});
      },
       async cancel(user) {
          console.log(user.name, " cancelled.");
           await db
                .collection('waiting')
                .doc(user.id)
                .delete()
                .then()
                .catch();
       },
      computeTimeDiff(date1) {
        let date2 = Date.now();
        return date.getDateDiff(date2, date1, 'minutes');
      },
    },
    computed: {
      ActiveUsernames: function () {
        return this.usernames.filter(status => status.active == true);
      }
    },
    created() {
      this.initialize();
    },
  }
</script>