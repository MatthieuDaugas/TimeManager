<template>
  <div id="date-filters">
    <DateSetter
      label="Start"
      v-on:setDate="setDate($event, 'start')"
      v-bind:prevalue="prevalue.start"
    />
    <DateSetter
      label="End"
      v-on:setDate="setDate($event, 'end')"
      v-bind:prevalue="prevalue.end"
    />
    <div class="form-bottom">
      <b-button
        variant="primary"
        @click="submit()"
        :disabled="!start || !end || error"
        >{{ submitText }}</b-button
      >
      <div class="error-div">
        <span v-if="error" class="error"
          >Error: The end date cannot be before the start date</span
        >
      </div>
    </div>
  </div>
</template>

<script>
import DateSetter from "./DateSetter";

export default {
  data: function() {
    return {
      error: false,
      start: null,
      end: null
    };
  },
  props: {
    submitText: null,
    prevalue: {
      default: ()=>({
        start: null,
        end: null
      })
    }
  },
  components: {
    DateSetter
  },
  methods: {
    setDate: function(event, moment) {
      this[moment] = event;
      if (this.start && this.end) {
        const start = new Date(this.start).getTime();
        const end = new Date(this.end).getTime();
        this.error = start > end;
      } else {
        this.error = null;
      }
    },
    submit: function() {
      this.$emit("submit", { start: this.start, end: this.end });
    }
  }
};
</script>

<style lang="scss">
.form-bottom {
  .error-div {
    margin-top: 5px;
    height: 30px;
    .error {
      color: red;
    }
  }
}
</style>