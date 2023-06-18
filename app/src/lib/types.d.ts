export interface OwnedAspect {
    note: string;
    time: string;
  }
  
  export interface OwnedAspects {
    [name: string]: OwnedAspect[];
  }
  

  export interface AspectData {
    [name: string]: {
      category: string;
      desc: string;
      in_codex: boolean;
      class: string;
    };
  };