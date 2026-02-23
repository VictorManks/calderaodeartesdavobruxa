defmodule CalderaodeartedavobruxaWeb.OpinionLiveTest do
  use CalderaodeartedavobruxaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Calderaodeartedavobruxa.AccountsFixtures

  @create_attrs %{ratin: 42, opinion_text: "some opinion_text"}
  @update_attrs %{ratin: 43, opinion_text: "some updated opinion_text"}
  @invalid_attrs %{ratin: nil, opinion_text: nil}

  setup :register_and_log_in_user

  defp create_opinion(%{scope: scope}) do
    opinion = opinion_fixture(scope)

    %{opinion: opinion}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_opinion]

    test "lists all opinions", %{conn: conn, opinion: opinion} do
      {:ok, _index_live, html} = live(conn, ~p"/opinions")

      assert html =~ "Listing Opinions"
      assert html =~ opinion.opinion_text
    end

    test "saves new opinion", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/opinions")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Opinion")
               |> render_click()
               |> follow_redirect(conn, ~p"/opinions/new")

      assert render(form_live) =~ "New Opinion"

      assert form_live
             |> form("#opinion-form", opinion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#opinion-form", opinion: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/opinions")

      html = render(index_live)
      assert html =~ "Opinion created successfully"
      assert html =~ "some opinion_text"
    end

    test "updates opinion in listing", %{conn: conn, opinion: opinion} do
      {:ok, index_live, _html} = live(conn, ~p"/opinions")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#opinions-#{opinion.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/opinions/#{opinion}/edit")

      assert render(form_live) =~ "Edit Opinion"

      assert form_live
             |> form("#opinion-form", opinion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#opinion-form", opinion: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/opinions")

      html = render(index_live)
      assert html =~ "Opinion updated successfully"
      assert html =~ "some updated opinion_text"
    end

    test "deletes opinion in listing", %{conn: conn, opinion: opinion} do
      {:ok, index_live, _html} = live(conn, ~p"/opinions")

      assert index_live |> element("#opinions-#{opinion.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#opinions-#{opinion.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_opinion]

    test "displays opinion", %{conn: conn, opinion: opinion} do
      {:ok, _show_live, html} = live(conn, ~p"/opinions/#{opinion}")

      assert html =~ "Show Opinion"
      assert html =~ opinion.opinion_text
    end

    test "updates opinion and returns to show", %{conn: conn, opinion: opinion} do
      {:ok, show_live, _html} = live(conn, ~p"/opinions/#{opinion}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/opinions/#{opinion}/edit?return_to=show")

      assert render(form_live) =~ "Edit Opinion"

      assert form_live
             |> form("#opinion-form", opinion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#opinion-form", opinion: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/opinions/#{opinion}")

      html = render(show_live)
      assert html =~ "Opinion updated successfully"
      assert html =~ "some updated opinion_text"
    end
  end
end
