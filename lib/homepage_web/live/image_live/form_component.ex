defmodule HomepageWeb.ImageLive.FormComponent do
  use HomepageWeb, :live_component

  alias Homepage.Posts

  @impl true
  def update(%{image: image} = assigns, socket) do
    changeset = Posts.change_image(image)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .png .webp .mp4), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"image" => image_params}, socket) do
    changeset =
      socket.assigns.image
      |> Posts.change_image(image_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"image" => image_params}, socket) do
    save_image(
      socket,
      socket.assigns.action,
      image_params
    )
  end

  defp save_image(socket, :edit, image_params) do
    case Posts.update_image(socket.assigns.image, image_params) do
      {:ok, _image} ->
        {:noreply,
         socket
         |> put_flash(:info, "Image updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_image(socket, :new, image_params) do
    [uploaded_file_location | _] =
      consume_uploaded_entries(socket, :image, fn %{path: path},
                                                  %{client_name: client_name, uuid: uuid, client_type: client_type} ->
        dest = Path.join("documents/", uuid) <> Path.extname(client_name)

        temp_image = File.read!(path)
        storage_name = System.get_env("DO_STORAGE_NAME")
        do_region = System.get_env("DO_REGION")

        %{body: _} =
          ExAws.S3.put_object(storage_name, dest, temp_image, %{acl: :public_read, content_type: client_type})
          |> ExAws.request!()

        {:ok,
         "https://#{storage_name}.#{do_region}.digitaloceanspaces.com/documents/#{Path.basename(dest)}"}
      end)

    image_params =
      Map.merge(image_params, %{
        "link" => uploaded_file_location,
        "image" => uploaded_entries(socket, :image)
      })

    case Posts.create_image(image_params) do
      {:ok, _image} ->
        {:noreply,
         socket
         |> put_flash(:info, "Image created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
