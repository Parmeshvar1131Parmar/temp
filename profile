import CommonHeader from 'components/layouts/components/Header';
import { useSelector, useDispatch } from 'react-redux';
import { getCurrentUser } from 'redux-toolkit/slices/authSlice';
import { AiOutlineVideoCameraAdd } from 'react-icons/ai';
import { FaRegHeart } from 'react-icons/fa';
import { getLikeItem, setLikes } from 'redux-toolkit/slices/likeSlice';
import { getItem, setWatchlist } from 'redux-toolkit/slices/watchlistSlice';
import { useLogout } from 'modules/auth/services';
import Button from 'components/Button/Button';
import { useEffect } from 'react';
import { fetchLikes, fetchWatchlist } from 'services/api'; // Assume these functions are defined in services/api.js

const Profile = () => {
  const dispatch = useDispatch();
  const user = useSelector(getCurrentUser);
  const { likes } = useSelector(getLikeItem);
  const { watchlist } = useSelector(getItem);
  const { logoutApi } = useLogout();

  useEffect(() => {
    const fetchData = async () => {
      if (user?.id) {
        try {
          const [likesResponse, watchlistResponse] = await Promise.all([
            fetchLikes(user.id),
            fetchWatchlist(user.id),
          ]);
          dispatch(setLikes(likesResponse.data));
          dispatch(setWatchlist(watchlistResponse.data));
        } catch (error) {
          console.error('Failed to fetch data:', error);
        }
      }
    };
    fetchData();
  }, [dispatch, user?.id]);

  const logout = async () => {
    await logoutApi();
  };

  return (
    <div className="bg-black min-h-[calc(100dvh_-_0px)]">
      <CommonHeader />
      <div className="max-w-2xl mx-4 sm:max-w-sm md:max-w-sm lg:max-w-sm xl:max-w-sm sm:mx-auto md:mx-auto lg:mx-auto xl:mx-auto mt-32 bg-white shadow-xl rounded-lg text-gray-900">
        <div className="rounded-t-lg h-32 overflow-hidden">
          <img
            className="object-cover object-top w-full"
            src="https://images.unsplash.com/photo-1549880338-65ddcdfd017b?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjE0NTg5fQ"
            alt="Cover"
          />
        </div>
        <div className="mx-auto w-32 h-32 relative -mt-16 border-4 border-white rounded-full overflow-hidden">
          <img
            className="object-cover object-center h-32"
            src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjE0NTg5fQ"
            alt="Profile"
          />
        </div>
        <div className="text-center mt-6">
          <h2 className="font-semibold text-2xl">
            {user?.first_name} {user?.last_name}
          </h2>
          <p className="text-gray-500 text-sm">{user?.email}</p>
        </div>
        <ul className="py-4 mt-4 text-gray-700 flex items-center justify-around border-t border-gray-200">
          <li className="flex flex-col items-center justify-center">
            <AiOutlineVideoCameraAdd className="w-8 h-8 text-gray-600" />
            <div className="text-xl font-semibold mt-2">{watchlist.length}</div>
            <div className="text-gray-500 text-sm">Watchlist</div>
          </li>
          <li className="flex flex-col items-center justify-center">
            <FaRegHeart className="w-8 h-8 text-gray-600" />
            <div className="text-xl font-semibold mt-2">{likes.length}</div>
            <div className="text-gray-500 text-sm">Likes</div>
          </li>
        </ul>
        <div className="flex justify-center mt-6">
          <Button
            onClickHandler={logout}
            className="focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900"
          >
            Log out
          </Button>
        </div>
      </div>
    </div>
  );
};

export default Profile;
