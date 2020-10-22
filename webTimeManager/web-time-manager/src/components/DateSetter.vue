<template>
  <div class="date-filter">
    <label for="">{{ label }}</label>
    <div class="inputs">
      <input type="date" v-model="date" @change="assembleDate()" />
      <input type="time" v-model="time" @change="assembleDate()" />
    </div>
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      valueSend: false,
      date: null,
      time: null
    };
  },
  props: ["label", "error", "prevalue"],
  created: function() {
    if (this.prevalue) {
        const split = this.prevalue.split(' at ');
        this.date = split[0].split('/').reverse().join('-')
        const splitTime = split[1].split(':');
        this.time = `${splitTime[0]}:${splitTime[1]}`
        this.assembleDate();
    }
  },
  methods: {
    assembleDate() {
      if (this.date && this.time) {
        this.valueSend = true;
        this.$emit("setDate", `${this.date} ${this.time}`);
      } else if (this.valueSend) {
        this.valueSend = false;
        this.$emit("setDate", null);
      }
    }
  }
};
</script>

<style lang="scss">
.date-filter {
  display: flex;
  justify-content: space-between;
  flex-direction: column;
  & label {
    font-size: 20px;
  }
  & .inputs {
    margin-bottom: 25px;
    display: flex;
    justify-content: space-between;
    & input {
      padding: 8px;
      font-size: 15px;
      border-radius: 10px;
      border: 1px solid rgba(80, 80, 80, 0.4);
    }
  }
}
</style>