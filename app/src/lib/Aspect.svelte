<script lang='ts'>
    import { Card } from 'flowbite-svelte';
    import AddOwned  from './AddOwned.svelte';
    import ListOwned  from './ListOwned.svelte';
  
    export let aspect;
    export let ownedList = [];

    function formatText(text) {
      const regex = /({[^}]+})/g;
      return text.replace(regex, '<strong>$1</strong>');
    }
</script>
  
<Card class="w-96">
    <h3 class="text-2xl font-bold mb-2">{aspect.name}, {aspect.category}</h3>
    <p class="text-base mb-4">{@html formatText(aspect.desc)}</p>
    <p class="text-base mb-4">In codex: {aspect.in_codex ? 'Yes' : 'No'}</p>
  
    <div class="flex">
      <div class="w-1/2 pr-4">
        <ListOwned aspectName={aspect.name} ownedList={ownedList} on:aspectUpdated />
      </div>
      <div class="w-1/2">
        <AddOwned aspectName={aspect.name} on:aspectUpdated />
      </div>
    </div>
  </Card>