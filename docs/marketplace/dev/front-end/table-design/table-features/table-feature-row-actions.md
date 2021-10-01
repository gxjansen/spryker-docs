---
title: Table Feature Row Actions
description: This article provides details about the Table Feature Row Actions component in the Components Library.
template: concept-topic-template
---

This article provides details about the Table Feature Row Actions component in the Components Library.

## Overview

Table Feature Row Actions is a feature of the Table Component that renders a drop down menu with actions applicable to the table row and when clicked triggers an Action which must be registered. Also this feature allows triggering actions via row click.
Each row has all actions by default, but they can be filtered using an array of action Ids in each row using the path configured by `availableActionsPath`.

Check out this example below to see how to use the Row Actions feature.

Feature configuration:

- `enabled` - enables the feature via config.  
- `actions` - is an array with actions that are displayed in the drop down menu and their type of registered [action](/docs/marketplace/dev/front-end/ui-components-library/actions/).  
- `click` - indicates which action is used for clicking the table row by its `id`.
- `rowIdPath` - is used for the `rowId` action context.  
- `availableActionsPath` - is path to an array with the available action IDs in the table data row (supports nested objects 
using dot notation for ex. `prop.nestedProp`).  

```html
<spy-table [config]="{
  dataSource: { ... },
  columns: [ ... ],
  rowActions: {
    enabled: true,
    actions: [
      { id: 'edit', title: 'Edit', type: 'edit-action' },
      { id: 'delete', title: 'Delete', type: 'delete-action' },
    ],
    click: 'edit',
    rowIdPath: 'sku',
    availableActionsPath: 'path.to.actions',
  },                                                                                        
}">
</spy-table>
```

## Feature registration

Register the feature:

```ts
@NgModule({
  imports: [
    TableModule.forRoot(),
    TableModule.withFeatures({
      rowActions: () =>
        import('@spryker/table.feature.row-actions').then(
          (m) => m.TableRowActionsFeatureModule,
        ),    
    }),
  ],
})
export class RootModule {}
```

## Interfaces

Below you can find interfaces for the Table Feature Pagination.

```ts
export interface TableRowActionsConfig extends TableFeatureConfig {
  actions?: TableRowActionBase[];
  click?: string;
  rowIdPath?: string;
  availableActionsPath?: string;
}

export interface TableRowActionBase extends TableActionBase {
  title: string;
  icon?: string;
}

export interface TableRowActionContext {
  row: TableDataRow;
  rowId?: string;
}
```