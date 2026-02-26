defmodule CalderaodeartesdavobruxaWeb.OpinionLiveTest do
  use CalderaodeartesdavobruxaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Calderaodeartesdavobruxa.AccountsFixtures
  import Calderaodeartesdavobruxa.GalleryFixtures

  defp create_opinion(%{scope: scope}) do
    opinion = opinion_fixture(scope)
    %{opinion: opinion}
  end

  describe "Index" do
    setup [:register_and_log_in_admin, :create_opinion]

    test "lista as opiniões do usuário", %{conn: conn, opinion: opinion} do
      {:ok, _index_live, html} = live(conn, ~p"/opinions")

      assert html =~ "Minhas Opiniões"
      assert html =~ opinion.opinion_text
    end

    test "exclui opinião na listagem", %{conn: conn, opinion: opinion} do
      {:ok, index_live, _html} = live(conn, ~p"/opinions")

      assert index_live
             |> element("#opinions-#{opinion.id} button[title='Excluir']")
             |> render_click()

      refute has_element?(index_live, "#opinions-#{opinion.id}")
    end
  end

  describe "Artwork Show - Nova opinião" do
    setup :register_and_log_in_user

    test "cria opinião com sucesso", %{conn: conn} do
      artwork = artwork_fixture()

      {:ok, show_live, _html} = live(conn, ~p"/artworks/#{artwork}")

      assert render(show_live) =~ "Deixe sua opinião"

      assert show_live
             |> form("#opinion-form", opinion: %{opinion_text: "", ratin: 1})
             |> render_change() =~ "can&#39;t be blank"

      html =
        show_live
        |> form("#opinion-form", opinion: %{opinion_text: "Obra incrível", ratin: 4})
        |> render_submit()

      assert html =~ "Opinião publicada com sucesso"
    end
  end

  describe "Form - Editar opinião" do
    setup [:register_and_log_in_user, :create_opinion]

    test "atualiza opinião com sucesso", %{conn: conn, opinion: opinion} do
      {:ok, form_live, _html} = live(conn, ~p"/opinions/#{opinion}/edit")

      assert render(form_live) =~ "Editar Opinião"

      assert form_live
             |> form("#opinion-form", opinion: %{opinion_text: nil, ratin: 1})
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#opinion-form", opinion: %{opinion_text: "Opinião atualizada", ratin: 2})
               |> render_submit()
               |> follow_redirect(conn, ~p"/opinions")

      html = render(index_live)
      assert html =~ "Opinião atualizada com sucesso"
      assert html =~ "Opinião atualizada"
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_opinion]

    test "exibe opinião", %{conn: conn, opinion: opinion} do
      {:ok, _show_live, html} = live(conn, ~p"/opinions/#{opinion}")

      assert html =~ "Show Opinion"
      assert html =~ opinion.opinion_text
    end

    test "atualiza opinião e retorna para show", %{conn: conn, opinion: opinion} do
      {:ok, show_live, _html} = live(conn, ~p"/opinions/#{opinion}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a[href*='edit']", "Edit opinion")
               |> render_click()
               |> follow_redirect(conn, ~p"/opinions/#{opinion}/edit?return_to=show")

      assert render(form_live) =~ "Editar Opinião"

      assert form_live
             |> form("#opinion-form", opinion: %{opinion_text: nil, ratin: 1})
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#opinion-form", opinion: %{opinion_text: "Opinião do show atualizada", ratin: 5})
               |> render_submit()
               |> follow_redirect(conn, ~p"/opinions/#{opinion}")

      html = render(show_live)
      assert html =~ "Opinião atualizada com sucesso"
      assert html =~ "Opinião do show atualizada"
    end
  end
end
