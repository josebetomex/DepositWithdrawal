// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Receiver.sol";



contract DepositWithdrawal is ERC721Receiver {


	mapping(address => uint256) private balances;
	mapping(address => uint256[]) private nfts;


	event Transfer(address indexed _from, address indexed _to, uint256 _id);

	IERC721 public nftContract;

	constructor(address _nftContract) public {
		nftContract = IERC721(_nftContract);
	}

	function widhdrawNFT(uint256 id) public  {

		require(nftContract.ownerOf(id) == msg.sender, "You are not the owner");

		require(nftContract.getApproved(id) == address(this), "You need to approve the transfer first");

		nftContract.safeTransferFrom( address(this), _msgSender(), id);

		balances[msg.sender] -= 1;
		_remove(_id, msg.sender);

		emit Transfer(address(this), msg.sender, id);
	}

	function getBalance(address addr) public view returns(uint256) {
		return balances[addr];
	}

	function getNFTs(address addr) public view returns(uint256[]) {
		return nfts[addr];
	}

	function _remove(uint256 _id, address _account) internal {
			uint256[] storage _ownerNodes = nfts[_account];
			uint length = _ownerNodes.length;
			uint _index = length;
			for (uint256 i = 0; i < length; i++) {
					if(_ownerNodes[i] == _id) {
							_index = i;
					}
			}
			if (_index >= _ownerNodes.length) return;
			_ownerNodes[_index] = _ownerNodes[length - 1];
			_ownerNodes.pop();
	}

	function onERC721Received(address operator, address from, uint256 id, bytes data) public returns(bytes4) {

				require(operator == address(nftContract), "Incorrect NFT ");

				nfts[_to].push(_id);
				balances[from] += 1;

				emit Transfer(from, address(this), id);

        return ERC721_RECEIVED;
  }


}
