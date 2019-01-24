/*
  Copyright (c) Microsoft Corporation. All rights reserved.
  Licensed under the MIT License. See License.txt in the project root for license information.
*/

using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Adxstudio.Xrm.Web.Mvc.Html;
using Adxstudio.Xrm.Web.UI.WebForms;
using Microsoft.Xrm.Portal.Web.UI.CrmEntityFormView;

namespace Adxstudio.Xrm.Web.UI.CrmEntityFormView
{
	/// <summary>
	/// Template used when rendering a subgrid cell.
	/// </summary>
	public abstract class SubgridCellTemplate : ICellTemplate
	{
		protected SubgridCellTemplate(FormXmlCellMetadata metadata)
		{
			if (metadata == null) throw new ArgumentNullException("metadata");

			Metadata = metadata;
		}

		/// <summary>
		/// Number of columns the cell is to take up.
		/// </summary>
		public virtual int? ColumnSpan
		{
			get { return Metadata.ColumnSpan; }
		}

		/// <summary>
		/// CSS Class name assigned.
		/// </summary>
		public string CssClass
		{
			get { return "subgrid"; }
		}

		/// <summary>
		/// Indicates if the control in the cell is enabled or disabled.
		/// </summary>
		public virtual bool Enabled
		{
			get { return !Metadata.Disabled; }
		}

		protected FormXmlCellMetadata Metadata { get; private set; }

		/// <summary>
		/// Number of rows a cell should take up
		/// </summary>
		public virtual int? RowSpan
		{
			get { return Metadata.RowSpan; }
		}

		public void InstantiateIn(Control container)
		{
			if (!Enabled)
			{
				return;
			}

            var html = Mvc.Html.EntityExtensions.GetHtmlHelper(Metadata.FormView.ContextName, container.Page.Request.RequestContext, container.Page.Response);

            var descriptionContainer = new HtmlGenericControl("div");

            if (Metadata.AddDescription && !string.IsNullOrWhiteSpace(Metadata.Description))
            {
                descriptionContainer.InnerHtml = html.Liquid(Metadata.Description);

                switch (Metadata.DescriptionPosition)
                {
                    case WebFormMetadata.DescriptionPosition.AboveLabel:
                        descriptionContainer.Attributes["class"] = !string.IsNullOrWhiteSpace(Metadata.CssClass) ? string.Join(" ", "description", Metadata.CssClass) : "description";
                        break;
                    case WebFormMetadata.DescriptionPosition.AboveControl:
                        descriptionContainer.Attributes["class"] = !string.IsNullOrWhiteSpace(Metadata.CssClass) ? string.Join(" ", "description above", Metadata.CssClass) : "description above";
                        break;
                    case WebFormMetadata.DescriptionPosition.BelowControl:
                        descriptionContainer.Attributes["class"] = !string.IsNullOrWhiteSpace(Metadata.CssClass) ? string.Join(" ", "description below", Metadata.CssClass) : "description below";
                        break;
                }
            }

            if (Metadata.AddDescription && !string.IsNullOrWhiteSpace(Metadata.Description) && Metadata.DescriptionPosition == WebFormMetadata.DescriptionPosition.AboveLabel)
            {
                container.Controls.Add(descriptionContainer);
            }


            var cellInfoContainer = new HtmlGenericControl("div");

			container.Controls.Add(cellInfoContainer);

			var cellInfoClasses = new List<string> { "info" };

			cellInfoContainer.Attributes["class"] = string.Join(" ", cellInfoClasses.ToArray());

			if (Metadata.ShowLabel)
			{
				cellInfoContainer.Controls.Add(new Label { AssociatedControlID = Metadata.ControlID, Text = Metadata.Label, ToolTip = Metadata.ToolTip });
			}

            if (Metadata.AddDescription && !string.IsNullOrWhiteSpace(Metadata.Description) && Metadata.DescriptionPosition == WebFormMetadata.DescriptionPosition.AboveControl)
            {
                container.Controls.Add(descriptionContainer);
            }

            var controlContainer = new HtmlGenericControl("div");

			container.Controls.Add(controlContainer);

			controlContainer.Attributes["class"] = "control";

			InstantiateControlIn(controlContainer);


            if (Metadata.AddDescription && !string.IsNullOrWhiteSpace(Metadata.Description) && Metadata.DescriptionPosition == WebFormMetadata.DescriptionPosition.BelowControl)
            {
                container.Controls.Add(descriptionContainer);
            }
        }

		protected abstract void InstantiateControlIn(HtmlControl container);
	}
}
